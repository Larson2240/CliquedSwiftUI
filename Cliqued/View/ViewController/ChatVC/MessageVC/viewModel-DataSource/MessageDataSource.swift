//
//  MessageDataSource.swift
//  SwapItSports
//
//  Created by C100-132 on 25/05/22.
//

import UIKit
import AVFoundation
import AVKit
import Lottie
import SKPhotoBrowser

class MessageDataSource: NSObject {
    
    private let viewController: MessageVC
    private let tableView: UITableView
    private let viewModel: MessageViewModel
    
    var selectedDownloadIndex = -1
    var selectedDownloadSection = -1
    var refresh:UIRefreshControl! = UIRefreshControl()
    var currentIndex = IndexPath()
    
    init(tableView: UITableView,viewModel: MessageViewModel,viewController: MessageVC){
        self.viewController = viewController
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.registerNib(nibNames: [SenderTVCell.identifier,ReceiverTVCell.identifier,MessageHeaderTVCell.identifier,SenderProfileTVCell.identifier,ReceiverProfileTVCell.identifier,SenderVideoTVCell.identifier,ReceiverVideoTVCell.identifier,SenderAudioTVCell.identifier,ReceiverAudioTVCell.identifier])
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        setupRefreshData()
    }
    
    //MARK: - Refresh Data Control
    func setupRefreshData() {
        self.refresh.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func refreshData() {
        
        self.refresh.beginRefreshing()
        viewController.is_fromReload = true
        if viewController.arrTemp.count != 0  {
            getOldMessagesFromLocal()
        }
    }
    
    func stopRefresh() {
        self.refresh.endRefreshing()
    }
    
    //MARK: - Fetch Message from local
    func getMessagesFromLocal()
    {
        let dict = NSMutableDictionary()
        
        dict.setValue(viewModel.getConversationId(), forKey: "conversation_id")
        dict.setValue(viewController.arrTemp.count, forKey: "offset")
        
        APP_DELEGATE.socketIOHandler?.fetchNewMessagesOfSender(data: dict)
    }
    
    func getOldMessagesFromLocal()
    {
        let dict = NSMutableDictionary()
        
        dict.setValue(viewModel.getConversationId(), forKey: "conversation_id")
        dict.setValue(viewController.arrTemp.count, forKey: "offset")
        
        APP_DELEGATE.socketIOHandler?.fetchOldMessagesOfSender(data: dict)
    }
    
    func reloadMessagesFromLocal(){
        if viewController.is_fromReload {
            viewController.is_fromReload = false
            
            let strPredicate = NSString(format: "((senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d))",viewController.sender_id,viewController.receiver_id,viewController.receiver_id,viewController.sender_id)
            
            let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            
            var arrMessageTemp = CoreDataAdaptor.sharedDataAdaptor.fetchMessageWhere1(predicate: NSPredicate (format: strPredicate as String),startOffset: viewController.arrTemp.count, sort: [sortDescriptor], limit: 20)
            
            if arrMessageTemp.count != 0 {
                arrMessageTemp = arrMessageTemp.reversed()
                viewController.arrTemp.insert(contentsOf: arrMessageTemp, at: 0)
                setupArray()
                tableView.reloadData()
                stopRefresh()
            }
            else
            {
                stopRefresh()
            }
            
            
        } else {
            stopRefresh()
            let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            let strPredicate = NSString(format: "(senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d)",viewController.sender_id,viewController.receiver_id,viewController.receiver_id,viewController.sender_id)
            
            viewController.arrTemp.removeAll()
            
            let arrMessages1 = CoreDataAdaptor.sharedDataAdaptor.fetchMessageWhere1(predicate: NSPredicate (format: strPredicate as String),startOffset: 0, sort: [sortDescriptor], limit: 20)
            viewController.arrTemp = arrMessages1.reversed()
            setupArray()
            
            if viewModel.arrMessages.count > 0 {
                tableView.reloadData()
                tableView.scrollToBottom()
            }
        }
    }
  
    func setupArray() {
        viewModel.arrMessages.removeAllObjects()
        var arrDates = viewController.arrTemp.map { $0.createdDate?.UTCToLocal(format: "yyyy-MM-dd")}
        arrDates = arrDates.removeDuplicates()
        
        for date in arrDates {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-ddd"
            let strDate = dateFormatter.date(from: date!)
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var components = calendar!.components(
                NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue |
                                NSCalendar.Unit.month.rawValue |
                                NSCalendar.Unit.day.rawValue |
                                NSCalendar.Unit.hour.rawValue |
                                NSCalendar.Unit.minute.rawValue |
                                NSCalendar.Unit.second.rawValue), from: strDate!)
            
            components.hour = 00
            components.minute = 00
            components.second = 00
            let startDate = calendar!.date(from: components)
            components.hour = 23
            components.minute = 59
            components.second = 59
            let endDate = calendar!.date(from: components)
            
            let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: true)
            
            let arrayMessageTemp = CoreDataAdaptor.sharedDataAdaptor.fetchMessageWhere(predicate: NSPredicate (format: "createdDate >= %@ AND createdDate =< %@ and ((senderId = %@ and receiverId = %@) or (senderId = %@ and receiverId = %@))", argumentArray: [startDate!, endDate!,viewController.sender_id,viewController.receiver_id,viewController.receiver_id,viewController.sender_id]), sort: [sortDescriptor])
            if arrayMessageTemp.count > 0 {
                var messageValues = messageList()
                messageValues.msgDate = date!
                messageValues.msg = arrayMessageTemp
                viewModel.arrMessages.add(messageValues)
            }
        }
    }
    
    //MARK: - Button Action
    @objc func buttonViewImages(_ sender: UIButton) {
        self.viewController.view.endEditing(true)
        if viewModel.arrMessages.count > 0 {
            
            let section = Int(sender.accessibilityLabel!)
            let selectedDownloadSection = section!
            let selectedDownloadIndex = sender.tag
            
            var arrImageFilter = [UIImage]()
            let obj = viewModel.arrMessages[selectedDownloadSection] as! messageList
            let arr = obj.msg
            let objMessage = arr[selectedDownloadIndex]
            
            if objMessage.messageType! == enumMessageType.image.rawValue {
                if let img = getImageFromDir("/Images/\(objMessage.mediaUrl ?? "")") {
                    arrImageFilter.append(img)
                }
                
                if arrImageFilter.count > 0 {
                    var images = [SKPhotoProtocol]()
                    let photo = SKPhoto.photoWithImage(arrImageFilter.first ?? UIImage())
                    images.append(photo)
                    let browser = SKPhotoBrowser(photos: images)
                    SKPhotoBrowserOptions.displayAction = false
                    viewController.present(browser, animated: true, completion: {})
                }
                
            } else if objMessage.messageType! == enumMessageType.video.rawValue {
                let strUrl = "\(UrlChatMedia)\(objMessage.mediaUrl ?? "")"
                let url = URL(string: strUrl)
                
                playVideo(url: url!)
            }
        }
    }
    
    @objc func buttonDownloadImage(_ sender: UIButton) {
        if viewModel.arrMessages.count > 0 {
            let section = Int(sender.accessibilityLabel!)
            selectedDownloadSection = section!
            selectedDownloadIndex = sender.tag
            
            if let cell = tableView.cellForRow(at: IndexPath(row: selectedDownloadIndex, section: selectedDownloadSection)) as? ReceiverProfileTVCell {
                cell.activityIndicator.startAnimating()
            }
            
            let obj = viewModel.arrMessages[section!] as! messageList
            let arr = obj.msg
            let objMessage = arr[sender.tag]
            
            let strUlr = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
            
            let url = URL(string: strUlr)
            downloadImage(from: url!, fileName: objMessage.thumbnailUrl!,section:selectedDownloadSection,row:selectedDownloadIndex)
            
        }
    }
    
    @objc func btnPlayAudioAction(_ sender: UIButton) {
        
        let section = sender.accessibilityHint!
        let row = sender.accessibilityValue!
        let fileName = sender.accessibilityLabel
        let strUrl = "\(UrlChatMedia)\(fileName ?? "")"
        print(strUrl)
        
        let indexpath = IndexPath(row: Int(row)!, section: Int(section)!)
        
        if viewController.audioPlayer != nil && currentIndex != indexpath {
            let tag = Int(viewController.audioPlayer.accessibilityLabel!)
            if tag == 1 {
                viewController.audioPlayer.pause()
                viewController.audioPlayer = nil
                viewController.meterTimer.invalidate()
                
                if let cell = tableView.cellForRow(at: currentIndex) as? SenderAudioTVCell {
                    
                    cell.buttonPlayAudio.setImage(UIImage(named: "ic_playchat"), for: .normal)
                    cell.animationView.isHidden = true
                    cell.viewWavesImage.isHidden = false
                }
            } else {
                viewController.audioPlayer.pause()
                viewController.audioPlayer = nil
                viewController.meterTimer.invalidate()
                if let cell = tableView.cellForRow(at: currentIndex) as? ReceiverAudioTVCell {
                    
                    cell.buttonPlayAudio.setImage(UIImage(named: "ic_playChat_white"), for: .normal)
                    cell.animationView.isHidden = true
                    cell.viewWavesImage.isHidden = false
                }
            }
        }
        
        let tag = sender.tag
        currentIndex = indexpath
        
        if tag == 1 {
            if let cell = tableView.cellForRow(at: indexpath) as? SenderAudioTVCell {
                
                if let myButtonImage = cell.buttonPlayAudio.image(for: .normal),
                   let buttonAppuyerImage = UIImage(named: "ic_playchat"),
                   myButtonImage.pngData() == buttonAppuyerImage.pngData()
                {
                    do
                    {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
                        try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                        try AVAudioSession.sharedInstance().setActive(true)
                        
                        let fileURL = checkAudioFileExists(withLink: strUrl)
                        if fileURL != nil {
                            self.viewController.audioPlayer = try AVAudioPlayer.init(contentsOf: fileURL!)
                            self.viewController.audioPlayer.delegate = self.viewController
                            self.viewController.audioPlayer.accessibilityLabel = "\(tag)"
                            self.viewController.audioPlayer.prepareToPlay()
                            self.viewController.audioPlayer.play()
                            self.viewController.audioPlayer.numberOfLoops = 0
                            self.viewController.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                            
                            let jeremyGif = UIImage.gifImageWithName("Blackwave")
                            let imageView = UIImageView(image: jeremyGif)
                            imageView.frame = CGRect(x: 0.0, y: 5.0, width: cell.animationView.frame.size.width, height: cell.animationView.frame.size.height)
                            cell.animationView.addSubview(imageView)
                            imageView.animationRepeatCount = 0
                            
                            cell.buttonPlayAudio.setImage(UIImage(named: "ic_pause_grey"), for: .normal)
                        }
                    }
                    catch let error {
                        if viewController.audioPlayer != nil {
                            viewController.audioPlayer.pause()
                            viewController.audioPlayer = nil
                            viewController.meterTimer.invalidate()
                        }
                        
                        cell.buttonPlayAudio.setImage(UIImage(named: "ic_playchat"), for: .normal)
                        cell.animationView.isHidden = true
                        cell.viewWavesImage.isHidden = false
                        self.viewController.showAlertPopup(message: error.localizedDescription)
                    }
                } else {
                    if viewController.audioPlayer != nil {
                        viewController.audioPlayer.pause()
                        viewController.audioPlayer = nil
                        viewController.meterTimer.invalidate()
                    }
                    
                    cell.buttonPlayAudio.setImage(UIImage(named: "ic_playchat"), for: .normal)
                    cell.animationView.isHidden = true
                    cell.viewWavesImage.isHidden = false
                }
            }
            
        } else {
            if let cell = tableView.cellForRow(at: indexpath) as? ReceiverAudioTVCell {
                
                if let myButtonImage = cell.buttonPlayAudio.image(for: .normal),
                   let buttonAppuyerImage = UIImage(named: "ic_playChat_white"),
                   myButtonImage.pngData() == buttonAppuyerImage.pngData()
                {
                    do
                    {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
                        try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                        try AVAudioSession.sharedInstance().setActive(true)
                        
                        let fileURL = checkAudioFileExists(withLink: strUrl)
                        
                        if fileURL != nil {
                            self.viewController.audioPlayer = try AVAudioPlayer.init(contentsOf: fileURL!)
                            self.viewController.audioPlayer.delegate = self.viewController
                            self.viewController.audioPlayer.accessibilityLabel = "\(tag)"
                            self.viewController.audioPlayer.prepareToPlay()
                            self.viewController.audioPlayer.play()
                            self.viewController.audioPlayer.numberOfLoops = 0
                            self.viewController.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                            
                            let jeremyGif = UIImage.gifImageWithName("whitewave")
                            let imageView = UIImageView(image: jeremyGif)
                            imageView.frame = CGRect(x: 0.0, y: 5.0, width: cell.animationView.frame.size.width, height: cell.animationView.frame.size.height)
                            cell.animationView.addSubview(imageView)
                            imageView.animationRepeatCount = 0
                            
                            cell.buttonPlayAudio.setImage(UIImage(named: "ic_pause_white"), for: .normal)
                        }
                    }
                    catch let error {
                        if viewController.audioPlayer != nil {
                            viewController.audioPlayer.pause()
                            viewController.audioPlayer = nil
                            viewController.meterTimer.invalidate()
                        }
                        
                        cell.buttonPlayAudio.setImage(UIImage(named: "ic_playChat_white"), for: .normal)
                        cell.animationView.isHidden = true
                        cell.viewWavesImage.isHidden = false
                        self.viewController.showAlertPopup(message: error.localizedDescription)
                    }
                } else {
                    if viewController.audioPlayer != nil {
                        viewController.audioPlayer.pause()
                        viewController.audioPlayer = nil
                        viewController.meterTimer.invalidate()
                    }
                    
                    cell.buttonPlayAudio.setImage(UIImage(named: "ic_playChat_white"), for: .normal)
                    cell.animationView.isHidden = true
                    cell.viewWavesImage.isHidden = false
                }
            }
        }
    }
    
    //MARK: - Play Video in AVPlayer
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.viewController.present(vc, animated: true) { vc.player?.play() }
    }
    
    //MARK: - Download Media in local
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, fileName:String,section:Int,row:Int) {
        getData(from: url) { data, response, error in
           
            guard let data = data, error == nil else { return }
            
            // always update the UI from the main thread
            DispatchQueue.main.async { [weak self] in
                
                let img = data.uiImage
                
                if let image1 = img {
                    self?.saveImageToDocumentDirectory(image: image1, fileName: fileName,section:section,row:row)
                }
            }
        }
    }
    
    func supports(type: String) -> Bool {
        let supportedTypes = CGImageDestinationCopyTypeIdentifiers() as NSArray
        return supportedTypes.contains(type)
    }
    
    func saveImageToDocumentDirectory(image: UIImage,fileName:String,section:Int,row:Int) {
        var objCBool: ObjCBool = true
        
        let mainPath = chatDir;
        let folderPath = mainPath + "/Images/"
        
        let isExist = FileManager.default.fileExists(atPath: folderPath, isDirectory: &objCBool)
        if !isExist {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = "\(fileName)"
        let imageUrl = documentDirectory.appendingPathComponent("Images/\(imageName)")
        
        let data = image.png
        
        if let data = data {
            do {
                try data.write(to: imageUrl)
                
                DispatchQueue.main.async {
                    if self.tableView.hasRowAtIndexPath(indexPath: IndexPath(row: row, section: section)) {
                        self.tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .none)
                    }
                }
            } catch {
                print("error saving", error)
            }
        }
    }
    
    func checkFile(filename:String) -> Bool {
        let path = chatDir
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("/Images/\(filename)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getImageFromDir(_ imageName: String) -> UIImage? {
        
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsUrl.appendingPathComponent(imageName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Not able to load image")
            }
        }
        return nil
    }
    
    //MARK: - Timer For Audio Chat
    @objc func updateAudioMeter(timer: Timer)
    {
        if viewController.audioPlayer != nil {
            let indexpath = currentIndex
            if viewController.audioPlayer.accessibilityLabel == "1" {
                if let cell = tableView.cellForRow(at: indexpath) as? SenderAudioTVCell {
                    
                    cell.animationView.isHidden = false
                    cell.viewWavesImage.isHidden = true
                }
            } else {
                if let cell = tableView.cellForRow(at: indexpath) as? ReceiverAudioTVCell {
                    
                    cell.animationView.isHidden = false
                    cell.viewWavesImage.isHidden = true
                }
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func checkAudioFileExists(withLink link: String) -> URL? {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        return filePath
                        
                    } else {
                        return downloadFile(withUrl: url, andFilePath: filePath)
                    }
                } catch {
                    return downloadFile(withUrl: url, andFilePath: filePath)
                }
            }else{
               
            }
        }else{
           
        }
        return nil
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL) -> URL? {
       
        do {
            let data = try Data.init(contentsOf: url)
            try data.write(to: filePath, options: .atomic)
           
            return filePath
            
        } catch {
           
        }
        
        return nil
    }
}

//MARK: - UITableview Delegate DataSource
extension MessageDataSource: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.arrMessages.count > 0 {
            let obj = viewModel.arrMessages[section] as! messageList
            let arr = obj.msg
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.arrMessages.count > 0 {
            let obj = viewModel.arrMessages[indexPath.section] as! messageList
            let arr = obj.msg
            let objMessage = arr[indexPath.row]
            
            // Sender Chat
            if Int(objMessage.senderId) == Constants.loggedInUser?.id ?? 0 {
                
                switch enumMessageType(rawValue: objMessage.messageType!)  {
                case .text:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: SenderTVCell.identifier, for: indexPath) as? SenderTVCell {
                        
                        cell.labelSenderText.text = objMessage.messageText?.fromBase64()
                        
                        if objMessage.createdDate != nil {
                            cell.labelDateTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
                        } else {
                            cell.labelDateTime.text = ""
                        }
                        
                        switch objMessage.messageStatus {
                        case enumMessageStatus.notDelivered.rawValue:
                            cell.imageStatusTick.image = UIImage(named: "ic_send_tick")
                            break
                            
                        case enumMessageStatus.delivered.rawValue:
                            cell.imageStatusTick.image = UIImage(named: "ic_delivered_tick")
                            break
                            
                        case enumMessageStatus.read.rawValue:
                            cell.imageStatusTick.image = UIImage(named: "ic_read_tick")
                            break
                            
                        default:
                            break
                        }
                        
                        return cell
                    }
                case .none:
                    return UITableViewCell()
                case .image:
                    let cell = getSenderImageCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)                    
                    return cell
                    
                case .video:
                    let cell = getSenderVideoCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)
                    return cell
                case .audio:
                    let cell = getSenderAudioCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)
                    return cell
                case .groupCreated:
                    return UITableViewCell()
                case .renamed:
                    return UITableViewCell()
                case .groupPicture:
                    return UITableViewCell()
                case .memberAdded:
                    return UITableViewCell()
                case .memberRemoved:
                    return UITableViewCell()
                case .memberLeft:
                    return UITableViewCell()
                case .videoCall:
                    return UITableViewCell()
                case .audioCall:
                    return UITableViewCell()
                }
              
            } else {
                
                // Receiver Chat
                switch enumMessageType(rawValue: objMessage.messageType!)  {
                case .text:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverTVCell.identifier, for: indexPath) as? ReceiverTVCell {
                        
                        cell.labelReceiverText.text = objMessage.messageText?.fromBase64()
                        
                        if objMessage.createdDate != nil {
                            cell.labelDateTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
                        } else {
                            cell.labelDateTime.text = ""
                        }
                        
                        return cell
                    }
                case .none:
                    return UITableViewCell()
                case .image:
                    let cell = getReceiverImageCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)
                    return cell
                    
                case .video:
                    let cell = getReceiverVideoCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)
                    return cell
                case .audio:
                    let cell = getReceiverAudioCell(tableView: tableView, indexPath: indexPath, objMessage: objMessage)
                    return cell
                case .groupCreated:
                    return UITableViewCell()
                case .renamed:
                    return UITableViewCell()
                case .groupPicture:
                    return UITableViewCell()
                case .memberAdded:
                    return UITableViewCell()
                case .memberRemoved:
                    return UITableViewCell()
                case .memberLeft:
                    return UITableViewCell()
                case .videoCall:
                    return UITableViewCell()
                case .audioCall:
                    return UITableViewCell()
                }
            }
        }
        return UITableViewCell()
    }
    
    func getSenderImageCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SenderProfileTVCell.identifier, for: indexPath) as? SenderProfileTVCell {
                                                      
            if objMessage.createdDate != nil {
                cell.labelTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelTime.text = ""
            }
            
            switch objMessage.messageStatus {
            case enumMessageStatus.notDelivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_send_tick")
                break
                
            case enumMessageStatus.delivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_delivered_tick")
                break
                
            case enumMessageStatus.read.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_read_tick")
                break
                
            default:
                break
            }
            
            var fileName = ""
            
           
            cell.activityIndicator.isHidden = true
            cell.buttonDownload.isHidden = true
            cell.buttonDownload.tag = indexPath.row
            cell.buttonDownload.accessibilityLabel = "\(indexPath.section)"
            cell.viewOption.isHidden = false
            
            cell.buttonImageTap.tag = indexPath.row
            cell.buttonImageTap.accessibilityLabel = "\(indexPath.section)"
            cell.buttonImageTap.addTarget(self, action: #selector(buttonViewImages(_:)), for: .touchUpInside)
                                    
            let isFileExists = checkFile(filename: "\(objMessage.thumbnailUrl ?? "")")
            if isFileExists {
                fileName = "\(chatDir)/Images/\(objMessage.thumbnailUrl ?? "")"
                                         
                if !fileName.isEmpty {
                    
                    cell.imageMessage.image = getImageFromDir("/Images/\(objMessage.thumbnailUrl ?? "")")
                                               
                    cell.viewOption.isHidden = true
                    cell.buttonDownload.isHidden = true
                    
                } else {
                    fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                        guard let self = self else { return }
                        
                        if let img = image {
                            cell.imageMessage.image = self.blurEffect(userImage: img)
                        }
                       
                        let strUlr = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                        
                        let url = URL(string: strUlr)
                        self.downloadImage(from: url!, fileName: objMessage.thumbnailUrl!,section:indexPath.section,row:indexPath.row)
                    }
                }
            } else {
                fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                
                cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                    guard let self = self else { return }
                    
                    if let img = image {
                        cell.imageMessage.image = self.blurEffect(userImage: img)
                    }
                    
                    let strUlr = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    let url = URL(string: strUlr)
                    self.downloadImage(from: url!, fileName: "\(objMessage.thumbnailUrl ?? "")",section:indexPath.section,row:indexPath.row)

                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getSenderVideoCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SenderVideoTVCell.identifier, for: indexPath) as? SenderVideoTVCell {
                                                      
            if objMessage.createdDate != nil {
                cell.labelTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelTime.text = ""
            }
            
            switch objMessage.messageStatus {
            case enumMessageStatus.notDelivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_send_tick")
                break
                
            case enumMessageStatus.delivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_delivered_tick")
                break
                
            case enumMessageStatus.read.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_read_tick")
                break
                
            default:
                break
            }
            
            var fileName = ""
                                    
            cell.activityIndicator.isHidden = true
            cell.buttonDownload.isHidden = true
            cell.buttonDownload.tag = indexPath.row
            cell.buttonDownload.accessibilityLabel = "\(indexPath.section)"
            cell.viewOption.isHidden = false
            
            cell.buttonImageTap.tag = indexPath.row
            cell.buttonImageTap.accessibilityLabel = "\(indexPath.section)"
            cell.buttonImageTap.addTarget(self, action: #selector(buttonViewImages(_:)), for: .touchUpInside)
                                    
            let isFileExists = checkFile(filename: "\(objMessage.thumbnailUrl ?? "")")
            if isFileExists {
                fileName = "\(chatDir)/Images/\(objMessage.thumbnailUrl ?? "")"
                                           
                if !fileName.isEmpty {
                    
                    cell.imageMessage.image = getImageFromDir("/Images/\(objMessage.thumbnailUrl ?? "")")
                                               
                    cell.viewOption.isHidden = true
                    cell.buttonDownload.isHidden = true
                    
                } else {
                    fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                        guard let self = self else { return }
                        
                        if let img = image {
                            cell.imageMessage.image = self.blurEffect(userImage: img)
                        }
                       
                        let strUlr = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                        
                        let url = URL(string: strUlr)
                        self.downloadImage(from: url!, fileName: objMessage.thumbnailUrl!,section:indexPath.section,row:indexPath.row)
                    }
                }
            } else {
                fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                
                cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                    guard let self = self else { return }
                    
                    if let img = image {
                        cell.imageMessage.image = self.blurEffect(userImage: img)
                    }
                    
                    let strUlr = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    let url = URL(string: strUlr)
                    self.downloadImage(from: url!, fileName: objMessage.thumbnailUrl!,section:indexPath.section,row:indexPath.row)

                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func getSenderAudioCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: SenderAudioTVCell.identifier, for: indexPath) as? SenderAudioTVCell {
            
            if objMessage.createdDate != nil {
                cell.labelDateTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelDateTime.text = ""
            }
            
            switch objMessage.messageStatus {
            case enumMessageStatus.notDelivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_send_tick")
                break
                
            case enumMessageStatus.delivered.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_delivered_tick")
                break
                
            case enumMessageStatus.read.rawValue:
                cell.imageStatusTick.image = UIImage(named: "ic_read_tick")
                break
                
            default:
                break
            }
            
            let strUrl = "\(UrlChatMedia)\(objMessage.mediaUrl ?? "")"
            let Url = URL(string: strUrl)
            
            let audioAsset = AVURLAsset.init(url: Url!, options: nil)

            audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
                guard let self = self else { return }
                
                var error: NSError? = nil
                let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                switch status {
                case .loaded: // Sucessfully loaded. Continue processing.
                    let duration = audioAsset.duration
                    let durationInSeconds = CMTimeGetSeconds(duration)
                    print(Int(durationInSeconds))
                    
                    DispatchQueue.main.async {
                        let (m,s) = self.secondsToHoursMinutesSeconds(Int(durationInSeconds))
                        cell.labelAudioTime.text = "\(m):\(s)"
                    }
                    
                    break
                case .failed: break // Handle error
                case .cancelled: break // Terminate processing
                default: break // Handle all other cases
                }
            }
            
            if indexPath == currentIndex && viewController.audioPlayer != nil {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_pause_grey"), for: .normal)
            } else {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_playchat"), for: .normal)
            }
            cell.buttonPlayAudio.accessibilityLabel = objMessage.mediaUrl
            cell.buttonPlayAudio.accessibilityHint = "\(indexPath.section)"
            cell.buttonPlayAudio.accessibilityValue = "\(indexPath.row)"
            
            cell.buttonPlayAudio.addTarget(self, action: #selector(btnPlayAudioAction(_:)), for: .touchUpInside)
                                    
            return cell
        }
        return UITableViewCell()
    }
    
    func getReceiverImageCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverProfileTVCell.identifier, for: indexPath) as? ReceiverProfileTVCell {
            
            if objMessage.createdDate != nil {
                cell.labelTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelTime.text = ""
            }
            
            var fileName = ""
            
            
            cell.activityIndicator.isHidden = true
            cell.buttonDownload.isHidden = false
            cell.imageTypeIcon.isHidden = false
            cell.buttonDownload.tag = indexPath.row
            cell.viewOption.isHidden = false
            cell.buttonDownload.accessibilityLabel = "\(indexPath.section)"
            cell.buttonImageTap.isHidden = true
            
            let isFileExists = checkFile(filename: "\(objMessage.thumbnailUrl ?? "")")
            if isFileExists {
                fileName = "\(chatDir)/Images/\(objMessage.thumbnailUrl ?? "")"
                
                if !fileName.isEmpty {
                    
                    cell.imageMessage.image = getImageFromDir("/Images/\(objMessage.thumbnailUrl ?? "")")
                    
                    cell.viewOption.isHidden = true
                    cell.buttonDownload.isHidden = true
                    cell.imageTypeIcon.isHidden = true
                    
                    cell.buttonImageTap.isHidden = false
                    cell.buttonImageTap.tag = indexPath.row
                    cell.buttonImageTap.accessibilityLabel = "\(indexPath.section)"
                    cell.buttonImageTap.addTarget(self, action: #selector(buttonViewImages(_:)), for: .touchUpInside)
                    
                } else {
                    fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                        guard let self = self else { return }
                        
                        cell.viewOption.isHidden = false
                        cell.buttonDownload.isHidden = false
                        cell.imageTypeIcon.isHidden = false
                        cell.buttonImageTap.isHidden = true
                        
                        if let img = image {
                            cell.imageMessage.image = self.blurEffect(userImage: img)
                        }
                        
                        cell.buttonDownload.addTarget(self, action: #selector(self.buttonDownloadImage(_:)), for: .touchUpInside)
                        
                    }
                }
            } else {
                fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                
                cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                    guard let self = self else { return }
                    
                    cell.viewOption.isHidden = false
                    cell.buttonDownload.isHidden = false
                    cell.imageTypeIcon.isHidden = false
                    cell.buttonImageTap.isHidden = true
                    
                    if let img = image {
                        cell.imageMessage.image = self.blurEffect(userImage: img)
                    }
                    
                    cell.buttonDownload.addTarget(self, action: #selector(self.buttonDownloadImage(_:)), for: .touchUpInside)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func getReceiverVideoCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverVideoTVCell.identifier, for: indexPath) as? ReceiverVideoTVCell {
                                                      
            if objMessage.createdDate != nil {
                cell.labelTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelTime.text = ""
            }
            
            var fileName = ""
          
            cell.activityIndicator.isHidden = true
            cell.buttonDownload.isHidden = false
            cell.buttonDownload.tag = indexPath.row
            cell.buttonDownload.accessibilityLabel = "\(indexPath.section)"
            cell.imageTypeIcon.isHidden = false
            cell.viewOption.isHidden = false
            
            cell.buttonImageTap.isHidden = true
            
            cell.buttonImageTap.tag = indexPath.row
            cell.buttonImageTap.accessibilityLabel = "\(indexPath.section)"
            cell.buttonImageTap.addTarget(self, action: #selector(buttonViewImages(_:)), for: .touchUpInside)
                                    
            let isFileExists = checkFile(filename: "\(objMessage.thumbnailUrl ?? "")")
            if isFileExists {
                fileName = "\(chatDir)/Images/\(objMessage.thumbnailUrl ?? "")"
                                           
                if !fileName.isEmpty {
                    
                    cell.imageMessage.image = getImageFromDir("/Images/\(objMessage.thumbnailUrl ?? "")")
                                               
                    cell.viewOption.isHidden = true
                    cell.buttonDownload.isHidden = true
                    cell.imageTypeIcon.isHidden = true
                    cell.buttonImageTap.isHidden = false
                    
                } else {
                    fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                    
                    cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                        guard let self = self else { return }
                        
                        cell.viewOption.isHidden = false
                        cell.buttonDownload.isHidden = false
                        cell.imageTypeIcon.isHidden = false
                        cell.buttonImageTap.isHidden = true
                        
                        if let img = image {
                            cell.imageMessage.image = self.blurEffect(userImage: img)
                        }
                        
                        cell.buttonDownload.addTarget(self, action: #selector(self.buttonDownloadImage(_:)), for: .touchUpInside)

                    }
                }
            } else {
                fileName = "\(UrlChatMedia)\(objMessage.thumbnailUrl ?? "")"
                
                cell.imageMessage.sd_setImage(with: URL(string: fileName), placeholderImage: UIImage(), options: .highPriority) { [weak self] image, error, type, ulr in
                    guard let self = self else { return }
                    
                    cell.viewOption.isHidden = false
                    cell.buttonDownload.isHidden = false
                    cell.imageTypeIcon.isHidden = false
                    cell.buttonImageTap.isHidden = true
                    
                    if let img = image {
                        cell.imageMessage.image = self.blurEffect(userImage: img)
                    }
                    
                    cell.buttonDownload.addTarget(self, action: #selector(self.buttonDownloadImage(_:)), for: .touchUpInside)

                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func getReceiverAudioCell(tableView: UITableView, indexPath: IndexPath, objMessage: CDMessage) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverAudioTVCell.identifier, for: indexPath) as? ReceiverAudioTVCell {
            
            if objMessage.createdDate != nil {
                cell.labelDateTime.text = objMessage.modifiedDate?.UTCToLocal(format: TIME_FORMAT)
            } else {
                cell.labelDateTime.text = ""
            }
            
            let strUrl = "\(UrlChatMedia)\(objMessage.mediaUrl ?? "")"
            let Url = URL(string: strUrl)
            
            let audioAsset = AVURLAsset.init(url: Url!, options: nil)

            audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
                guard let self = self else { return }
                
                var error: NSError? = nil
                let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                switch status {
                case .loaded: // Sucessfully loaded. Continue processing.
                    let duration = audioAsset.duration
                    let durationInSeconds = CMTimeGetSeconds(duration)
                    
                    DispatchQueue.main.async {
                        let (m,s) = self.secondsToHoursMinutesSeconds(Int(durationInSeconds))
                        cell.labelAudioTime.text = "\(m):\(s)"
                    }
                    
                    break
                case .failed:
                    cell.labelAudioTime.text = ""
                    break // Handle error
                case .cancelled:
                    cell.labelAudioTime.text = ""
                    break// Terminate processing
                default:
                    cell.labelAudioTime.text = ""
                    break // Handle all other cases
                }
            }
            
            if indexPath == currentIndex && viewController.audioPlayer != nil {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_pause_white"), for: .normal)
            } else {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_playChat_white"), for: .normal)
            }
            cell.buttonPlayAudio.accessibilityLabel = objMessage.mediaUrl
            cell.buttonPlayAudio.accessibilityHint = "\(indexPath.section)"
            cell.buttonPlayAudio.accessibilityValue = "\(indexPath.row)"
                                   
            cell.buttonPlayAudio.addTarget(self, action: #selector(btnPlayAudioAction(_:)), for: .touchUpInside)
                                                            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageHeaderTVCell.identifier) as! MessageHeaderTVCell
        
        let obj = viewModel.arrMessages[section] as! messageList
        let cdate = obj.msgDate
        let strDate = viewController.getChatDateFromServerForSection(strDate:cdate)
        cell.labelDate.text = strDate
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK: - Blur Effect in Chat Media
    func blurEffect(userImage: UIImage) -> UIImage? {
        var context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: userImage)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(15, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}
