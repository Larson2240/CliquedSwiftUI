
import StoreKit

class IAPHelper: NSObject {
    
    static let shared = IAPHelper()
    
    let SharedSecretKey = "ef2c8fff087e41f2b42e9df7211577b5"
    
    private var purchasedPackagesIds: Set<String> = []
    private var productsRequest: SKProductsRequest? = nil
    
    private var callbackForProducts: ((_ products: [SKProduct])->())?
    private var callbackForError: ((_ error: Error)->())?
    private var callbackForPurchase: ((_ transaction: SKPaymentTransaction)->())?
    
#if DEBUG
    let certificate = "StoreKitTestCertificate"
#else
    let certificate = "AppleIncRootCertificate"
#endif
    
    override init() {
    }
    
    public func getProducts(
        ofPackageIds packageIds: Set<String>,
        callbackForProducts: @escaping ((_ products: [SKProduct])->()),
        callbackForError: @escaping ((_ error: Error)->())) {
        
        self.callbackForProducts = callbackForProducts
        self.callbackForError = callbackForError
               
        for productIdentifier in packageIds {
            if let purchasedIds = UserDefaults.standard.value(forKey: "IAP") {
                if purchasedIds as! String == productIdentifier {
                    purchasedPackagesIds.insert(productIdentifier)
                    print("Previously purchased: \(productIdentifier)")
                } else {
                    //print("Not purchased: \(productIdentifier)")
                }
            }
        }
        
        SKPaymentQueue.default().add(self)

        productsRequest?.cancel()
        let productIdentifiers = NSSet(objects: P_month, P_6months, P_year)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func buy(product: SKProduct, callbackForPurchase: @escaping (_ transaction: SKPaymentTransaction)->()) {
        self.callbackForPurchase = callbackForPurchase
        if canMakePayments() {
            print("Buying \(product.productIdentifier)...")
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("purchase not found")
        }
    }
    
    public func isProductPurchased(_ productIdentifier: String) -> Bool {
        return purchasedPackagesIds.contains(productIdentifier)
    }
    
    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        callbackForProducts?(products)
        clearRequestAndHandler()
        
        print("Loaded products count: " + products.count.description)
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        callbackForError?(error)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        callbackForProducts = nil
        callbackForPurchase = nil
        callbackForError = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let state = transaction.transactionState
            
            switch state {
            case .purchased, .failed, .restored:
                print("transaction state \(state)")
                print("transaction id \(transaction.transactionIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                UserDefaults.standard.setValue(transaction.payment.productIdentifier, forKey: "IAP")
                purchasedPackagesIds.insert(transaction.payment.productIdentifier)
                callbackForPurchase?(transaction)
                clearRequestAndHandler()
                break
            case .deferred:
                break
            case .purchasing:
                break
            default:
                fatalError("No default action found.")
                break
            }
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                print("Transaction Failed \(transaction)")
                break
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                print("Transaction purchased or restored: \(transaction)")
                break
            case .deferred, .purchasing:
                print("Transaction in progress: \(transaction)")
                break
            @unknown default:
                break
            }
        }
    }
}

extension IAPHelper {
    
    func getReceiptData(
        responseData: @escaping (_ response: NSDictionary) -> Void,
        errorData: @escaping (_ error: String) -> Void
    ) {
             
        guard let receiptFileURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptFileURL) else {
            errorData("Something wen't wrong, Please try again later.")
            return
        }
        
//        let receiptString = receiptData.base64EncodedString(options:NSData.Base64EncodingOptions(rawValue: 0))
        
        let receiptString = receiptData.base64EncodedString()
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let allowedCharSet = CharacterSet(charactersIn: allowedCharacters)
        let encodedString = receiptString.addingPercentEncoding(withAllowedCharacters: allowedCharSet)
        
        let jsonDict: NSDictionary =
            [
                "receipt-data" : encodedString ?? "",
                "password" : IAPHelper.shared.SharedSecretKey
            ]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            let sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
            let liveServer = "https://buy.itunes.apple.com/verifyReceipt"
            
            let verifyReceiptURL: String
            
            switch SwiftConfig.appConfiguration {
            case .debug, .testFlight:
                verifyReceiptURL = sandbox
                break
            case .appStore:
                verifyReceiptURL = liveServer
                break
            }
            
            print(verifyReceiptURL)
            print(jsonDict)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let task = URLSession.shared.dataTask(with: storeRequest, completionHandler: { (data, response, error) in
                do {
                    if let data = data {
                        if let res = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                            if let environment = res["environment"] as? String, !environment.isEmpty {
                                responseData(res)
                                return
                            } else {
                                errorData("status \(res["status"] ?? "")")
                            }
                        } else {
                            errorData("data not found")
                        }
                    } else {
                        errorData(error!.localizedDescription)
                    }
                } catch let parseError {
                    errorData(parseError.localizedDescription)
                }
            })
            task.resume()
        } catch let parseError {
            errorData(parseError.localizedDescription)
        }
    }
}

enum AppConfiguration: String {
    case debug
    case testFlight = "testflight"
    case appStore = "live"
}

struct SwiftConfig {
    
    
    
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    // This can be used to add debug statements.
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        } else {
            return .appStore
        }
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        // we're on the simulator - calculate pretend movement
        return true
        #endif
        
        // we're on a device – use the accelerometer
        return false
    }
}
