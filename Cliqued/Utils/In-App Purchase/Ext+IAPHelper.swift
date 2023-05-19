
import StoreKit

private let BaseBundle = "com.ios.cliqued."

let P_month = BaseBundle + "month"
let P_6months = BaseBundle + "6_months"
let P_year = BaseBundle + "year"

extension Set where Element == String {
    
    //All - Identifiers
    static var InAppAllPackageIds: Set<String> {
        get {
            return [
                P_month,
                P_6months,
                P_year
            ]
        }
    }
    
}
