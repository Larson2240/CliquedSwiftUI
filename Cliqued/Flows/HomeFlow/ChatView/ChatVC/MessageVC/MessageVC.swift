//
//  MessageVC.swift
//  Cliqued
//
//  Created by C100-132 on 28/01/23.
//

import UIKit
import GrowingTextView
import SDWebImage
import SocketIO
import TLPhotoPicker
import Photos
import MobileCoreServices
import AVFoundation
import PushKit
import CallKit
import TwilioVideo
import IQKeyboardManager

class MessageVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var textView: GrowingTextView! {
        didSet {
            textView.layer.cornerRadius = textView.frame.height / 2
            textView.layer.masksToBounds = true
            textView.font = CustomFont.THEME_FONT_Book(14)
        }
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelReceiverStatus: UILabel! {
        didSet {
            labelReceiverStatus.font = CustomFont.THEME_FONT_Book(12)
            labelReceiverStatus.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet var labelReceiverName: UILabel! {
        didSet {
            
            labelReceiverName.font = CustomFont.THEME_FONT_Medium(16)
            labelReceiverName.textColor = Constants.color_NavigationBarText
        }
    }
    @IBOutlet var imageReceiverProfile: UIImageView! {
        didSet {
            imageReceiverProfile.layer.cornerRadius = imageReceiverProfile.frame.height / 2
            imageReceiverProfile.layer.masksToBounds = true
        }
    }
    @IBOutlet var buttonSend: UIButton!
    @IBOutlet var buttonAudio: UIButton!
    @IBOutlet var labelOnlineYConstant: NSLayoutConstraint!
    @IBOutlet var bottomViewConstant: NSLayoutConstraint!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var callStackView: UIStackView!
    @IBOutlet var callStackViewWidthConstant: NSLayoutConstraint!
    @IBOutlet var viewSendButton: UIView!
    @IBOutlet var textViewTrailingConstant: NSLayoutConstraint!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var sendViewWidthConstant: NSLayoutConstraint!
    
    //MARK: Variables
    var viewModel = MessageViewModel()
    var viewModelBlockedUser = ActivityUserDetailsViewModel()
    var dataSource: MessageDataSource?
    var sender_id = UserDefaults.standard.string(forKey: kUserToken)
    var receiver_id  = 0
    var receiver_name = ""
    var receiver_profile = ""
    var conversation_id = 0
    var receiver_last_seen = ""
    var receiver_is_online = ""
    var receiver_is_last_seen_enable = ""
    var recevier_chat_status = ""
    var arrTemp = [CDMessage]()
    var is_SendText = false
    var is_fromReload = false
    var arrayOfSelectedImages = [Any]()
    var isAudioRecordingGranted: Bool = false
    var isRecording = false
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var filename = ""
    var isPlaying = false
    var avPlayer : AVPlayer!
    var meterTimer:Timer!
    var is_fromMatchScreen = false
    var is_blocked = false
    var i = 0
   
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadMethod()
        viewModel.removeAllChatMedia()
        viewModel.removeAllThumbnailMedia()
        handleApiResponse()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        buttonAudio.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.shouldRequireFailure(of: longPress)
        buttonAudio.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        viewModel.setSenderId(value: "\(sender_id)")
        viewModel.setReceiverId(value: "\(receiver_id)")
        viewModel.setReceiverName(value: receiver_name)
        viewModel.setReceiverProfile(value: receiver_profile)
        viewModel.setConversationId(value: "\(conversation_id)")
        
        APP_DELEGATE.socketIOHandler?.delegate = self
        
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue("\(sender_id)", forKey: "receiver_id")
        dict.setValue("0", forKey: "message_id")
        dict.setValue("\(receiver_id)", forKey: "sender_id")
        dict.setValue("\(enumMessageStatus.read.rawValue)", forKey: "message_status")
        APP_DELEGATE.socketIOHandler?.updateMessageStatus(data: dict)
        
        dataSource!.reloadMessagesFromLocal()
        dataSource!.getMessagesFromLocal()
        
        if viewModel.getMessageText().isEmpty {
            textView.text = Constants_Message.title_textview_placeholder
            textView.textColor = Constants.color_MediumGrey
            viewModel.setMessageText(value: "")
            is_SendText = false
        } else {
            textView.textColor = Constants.color_DarkGrey
            is_SendText = true
        }
        
        check_record_permission()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        if audioPlayer != nil && audioRecorder != nil {
            audioPlayer.pause()
            audioRecorder.stop()
            audioRecorder = nil
        }
        self.view.endEditing(true)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            bottomViewConstant.constant = keyboardSize.height
                        
            is_SendText = true
            reloadButton()
            
            if viewModel.arrMessages.count > 0 {
                tableView.scrollToBottom()
             }
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewConstant.constant = 8
        self.view.layoutIfNeeded()
    }
    
    //MARK: Button Method
    @IBAction func buttonSettingAction(_ sender: UIButton) {
        self.textView.endEditing(true)
        self.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_block, title: "", message: Constants.label_blockAlertMsg) { [weak self] in
            guard let self = self else { return }
            
            let activityUserId = self.viewModel.getReceiverId()
            self.viewModelBlockedUser.callBlcokUserAPI(counterUserId: activityUserId)
        }
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        if is_fromMatchScreen {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonAudioCallAction(_ sender: UIButton) {
        self.textView.endEditing(true)
        let room_name = "\(Date().ticks)_\(sender_id)"
        viewModel.setSenderId(value: "\(sender_id)")
        viewModel.setReceiverId(value: "\(receiver_id)")
        viewModel.setRoomName(value: "\(room_name)")
        viewModel.setIsVideo(value: "0")
        viewModel.apiCheckOtherUser()
    }
        
    @IBAction func buttonVideoCallAction(_ sender: UIButton) {
        self.textView.endEditing(true)
        let room_name = "\(Date().ticks)_\(sender_id)"
        viewModel.setSenderId(value: "\(sender_id)")
        viewModel.setReceiverId(value: "\(receiver_id)")
        viewModel.setRoomName(value: "\(room_name)")
        viewModel.setIsVideo(value: "1")
        viewModel.apiCheckOtherUser()
    }    
    
    @IBAction func buttonSendAction(_ sender: UIButton) {
        if viewModel.getMessageText().count == 0 {
            self.showAlertPopup(message: Constants_Message.title_textview_validation)
        } else {
            viewModel.sendMessage()
            textView.text = ""
        }
    }
    
    @IBAction func buttonGalleryAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.arrayOfSelectedImages.removeAll()
        self.viewModel.removeAllChatMedia()
        self.viewModel.removeAllThumbnailMedia()
        
        openTLPhotoPicker()
    }
    
    @IBAction func buttonCameraAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.arrayOfSelectedImages.removeAll()
        self.viewModel.removeAllChatMedia()
        self.viewModel.removeAllThumbnailMedia()
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
          switch cameraAuthorizationStatus {
        case .notDetermined:
              DispatchQueue.main.async {
                  self.requestCameraPermission()
              }
        case .authorized:
              DispatchQueue.main.async {
                  self.openCamera()
              }
        case .restricted, .denied:
              DispatchQueue.main.async {
                  self.alertCameraAccessNeeded()
              }
        }
    }
       
   
    //MARK: - Audio Recording Methods
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        finishAudioRecording(success: false)
        showToast(message: Constants_Message.record_audio_hold)
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            filename = "\(Date().ticks)_\(sender_id)_\(receiver_id).m4a"
            
            if(isRecording)
            {
                finishAudioRecording(success: true)
            }
            else
            {
                if isAudioRecordingGranted {
                    setup_recorder()
                    audioRecorder.record()
                    isRecording = true
                    showToast(message: Constants_Message.record_audio_continue)
                    
                    switch i {
                            case 1:
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.error)

                            case 2:
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)

                            case 3:
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.warning)

                            case 4:
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()

                            case 5:
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()

                            case 6:
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()

                            default:
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
                                i = 0
                    }                  
                } else {
                    alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.open_setting_title, title: "", message: Constants_Message.open_settin_in_device_text) {
                         UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        } else if gesture.state == .ended || gesture.state == .cancelled || (gesture.state == .changed && !gesture.view!.bounds.contains(gesture.location(in: gesture.view))) {
            finishAudioRecording(success: true)
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL
    {
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        print(filePath)
        return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(.playAndRecord, mode: .default)
                try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                try session.setActive(true)
                let settings:[String : Any] = [ AVFormatIDKey : kAudioFormatMPEG4AAC,
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey : 2,
                AVSampleRateKey : 44100.0 ] as [String : Any]
                
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
                audioRecorder.isMeteringEnabled = true
            }
            catch let error {
                self.showAlertPopup(message: error.localizedDescription)
            }
        }
        else
        {
            alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.open_setting_title, title: "", message: Constants_Message.open_settin_in_device_text) {
                 UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            if audioRecorder != nil {
                audioRecorder.stop()
                audioRecorder = nil
                arrayOfSelectedImages.removeAll()
                arrayOfSelectedImages.append(getFileUrl())
                isRecording = false
                
                let data = try! Data.init(contentsOf: self.getFileUrl())                
                let mediaSize = Float(Double(data.count)/1024/1024)
                
                if mediaSize > Float(MEDIA_SIZE) {
                    self.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                
                    alertCustom(btnNo: Constants_Message.discard_title, btnYes: Constants_Message.send_title, title: "", message: Constants_Message.record_audio_send) { [weak self] in
                        guard let self = self else { return }
                        
                        self.viewModel.removeAllChatMedia()
                        self.viewModel.removeAllThumbnailMedia()
                        
                        self.viewModel.setChatMedia(value: self.getFileUrl())
                        self.viewModel.setThumbnailMedia(value: self.createThumbnailOfVideoFromFileURL(videoURL: self.getFileUrl().absoluteString)!)
                        self.viewModel.setMessageType(value: "\(enumMessageType.audio.rawValue)")
                        self.viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
                        self.viewModel.apiAddChatMedia()
                    }
                }
            }
        }
        else
        {
            self.showAlertPopup(message: Constants_Message.Chat_Recording_Failed)          
        }
    }
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    //MARK: - AVAudio Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        } else {
            finishAudioRecording(success: true)
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        let tag = Int(player.accessibilityLabel!)
        if tag == 1 {
            audioPlayer.pause()
            audioPlayer = nil
            meterTimer.invalidate()
            if let cell = tableView.cellForRow(at: dataSource!.currentIndex) as? SenderAudioTVCell {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_playchat"), for: .normal)
                cell.animationView.isHidden = true
                cell.viewWavesImage.isHidden = false
            }
        } else {
            audioPlayer.pause()
            audioPlayer = nil
            meterTimer.invalidate()
            if let cell = tableView.cellForRow(at: dataSource!.currentIndex) as? ReceiverAudioTVCell {
                cell.buttonPlayAudio.setImage(UIImage(named: "ic_playChat_white"), for: .normal)
                cell.animationView.isHidden = true
                cell.viewWavesImage.isHidden = false
            }
        }
    }
    
    //MARK: - Check Permission
    func check_record_permission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
            })
            break
        default:
            break
        
       }
    }
    
}

extension MessageVC {
    //MARK: Handle API response
    func handleApiResponse() {
        
        //If API success
        viewModelBlockedUser.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                
                let dict:NSMutableDictionary = NSMutableDictionary()
                dict.setValue(sender_id, forKey: "user_id")
                dict.setValue(self.receiver_id, forKey: "receiver_id")
                APP_DELEGATE.socketIOHandler?.UserBlockedEvent(data: dict)
                
                self.alertCustomForChat(btnNo: Constants.btn_cancel, btnYes: Constants_Message.btn_yes, title: "", message: Constants_Message.title_report_now) {
                    self.showAlerBox("", "You blocked \(self.receiver_name). Unblock them anytime under settings.") { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                } block: {
                    let reportuservc = ReportUserVC.loadFromNib()
                    reportuservc.reportedUserId = self.viewModel.getReceiverId()
                    self.navigationController?.pushViewController(reportuservc, animated: true)
                }
            }
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            let vc = VideoCallVC.loadFromNib()
            vc.sender_id = "\(self.sender_id)"
            vc.receiver_id = "\(self.receiver_id)"
            vc.accessToken = self.viewModel.getAccessToken()
            vc.roomName = self.viewModel.getRoomName()
            vc.userName = "\(self.labelReceiverName.text ?? "")"
            vc.is_audioCall = self.viewModel.getIsVideo() == "0" ? true : false
            Calling.otherUserProfile = self.viewModel.getReceiverProfile()            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        viewModel.isUserDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                
                if self.viewModel.arrayOfMainUserList.count > 0 {
                    let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
                    activityuserdetailsvc.objUserDetails = self.viewModel.arrayOfMainUserList[0]
                    activityuserdetailsvc.hidesBottomBarWhenPushed = true
                    activityuserdetailsvc.is_fromChatActivity = true
                    self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
                }
            }
        }
        
        viewModel.isMessageAdded.bind { [weak self] isSuccess in
            self?.dataSource!.reloadMessagesFromLocal()
        }
    }
}


// MARK: - UIImagePickerViewController
extension MessageVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            DispatchQueue.main.async { [weak self] in
                self?.openCamera()
            }
        })
    }
    
    func openCamera() {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.videoQuality = .typeMedium
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            imagePicker.videoMaximumDuration = 11
            imagePicker.cameraFlashMode = .off
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: Constants_Message.alert_title_warning, message: Constants_Message.alert_doNotHaveCamera, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants_Message.title_ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        
        self.arrayOfSelectedImages.removeAll()
        self.viewModel.removeAllChatMedia()
        self.viewModel.removeAllThumbnailMedia()
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType as String == kUTTypeMovie as String {
            if let videoURL = info[.mediaURL] as? URL {
                
                let data = try! Data.init(contentsOf: videoURL)
                
                let mediaSize = Float(Double(data.count)/1024/1024)
                
                if mediaSize > Float(MEDIA_SIZE) {
                    self.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                    
                    self.arrayOfSelectedImages.append(videoURL)
                    self.viewModel.setChatMedia(value: videoURL)
                    self.viewModel.setThumbnailMedia(value: self.createThumbnailOfVideoFromFileURL(videoURL: videoURL.absoluteString)!)
                    self.viewModel.setMessageType(value: "\(enumMessageType.video.rawValue)")
                    self.viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
                    self.viewModel.apiAddChatMedia()
                }
            }            
        } else {
            if let image = info[.editedImage] as? UIImage {
                let imgData: NSData = NSData(data: (image).jpegData(compressionQuality: 1)!)
                let mediaSize = Float(Double(imgData.count)/1024/1024)
                
                if mediaSize > Float(MEDIA_SIZE) {
                    self.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                    
                    self.arrayOfSelectedImages.append(image.fixedOrientation() ?? image)
                    self.viewModel.setChatMedia(value: image.fixedOrientation() ?? image)
                    self.viewModel.setThumbnailMedia(value: image.fixedOrientation() ?? image)
                    viewModel.setMessageType(value: "\(enumMessageType.image.rawValue)")
                    viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
                    self.viewModel.apiAddChatMedia()
                }
            }
        }
    }
    
    func alertCameraAccessNeeded() {
        
        self.alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.open_setting_title, title: "", message: Constants_Message.title_camera_permission_text) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}

extension MessageVC : TLPhotosPickerViewControllerDelegate {
    //MARK: - TLPhotosPicker Library
    func checkPhotoLibraryPermission(completion: (Bool) -> ()) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            completion(true)
            break
        case .denied, .restricted :
            //handle denied status
            completion(false)
            break
        case .notDetermined:
            // ask for permissions
            completion(true)
            break
        case .limited:
            completion(true)
            break
        @unknown default:
            break
        }
    }
    
    func openTLPhotoPicker() {
        checkPhotoLibraryPermission(completion: { [weak self] (value) -> Void in
            guard let self = self else { return }
            
            if value {
                let photoViewController = TLPhotosPickerViewController()
                photoViewController.delegate = self
                var configure = TLPhotosPickerConfigure()
                if(arrayOfSelectedImages.count == 0) {
                    configure.maxSelectedAssets = MaxChatMediaSelect
                } else {
                    configure.maxSelectedAssets = MaxChatMediaSelect - arrayOfSelectedImages.count
                }
                configure.allowedVideo = true
                configure.allowedLivePhotos = false
                configure.allowedPhotograph = true
                configure.allowedVideoRecording = false
                photoViewController.configure = configure
                
                self.present(photoViewController, animated: true, completion: nil)
            } else {
                self.alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.alert_title_setting, title: "", message: Constants_Message.alert_media_setting_message) {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        if withTLPHAssets.count > 0 {
            self.arrayOfSelectedImages.removeAll()
            self.viewModel.removeAllChatMedia()
            self.viewModel.removeAllThumbnailMedia()
            
            for i in withTLPHAssets{
                if i.phAsset?.mediaType == .image {
                    
                    let mediaSize = i.phAsset?.fileSize
                    
                    if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                        self.showAlertPopup(message: Constants_Message.validation_media_upload)
                    } else {
                                                
                        self.arrayOfSelectedImages.append(i.fullResolutionImage!.fixedOrientation() ?? i.fullResolutionImage!)
                        self.viewModel.setChatMedia(value: i.fullResolutionImage?.fixedOrientation() ?? i.fullResolutionImage as Any)
                        self.viewModel.setThumbnailMedia(value: i.fullResolutionImage!.fixedOrientation() ?? i.fullResolutionImage!)
                        viewModel.setMessageType(value: "\(enumMessageType.image.rawValue)")
                        viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
                        self.viewModel.apiAddChatMedia()
                    }
                } else if i.phAsset?.mediaType == .video {
                    
                    let mediaSize = i.phAsset?.fileSize
                    
                    if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                        self.showAlertPopup(message: Constants_Message.validation_media_upload)
                    } else {
                        i.exportVideoFile { url, strType in
                            self.arrayOfSelectedImages.append(url)
                            self.viewModel.setChatMedia(value: url)
                            self.viewModel.setThumbnailMedia(value: self.createThumbnailOfVideoFromFileURL(videoURL: url.absoluteString)!)
                            self.viewModel.setMessageType(value: "\(enumMessageType.video.rawValue)")
                            self.viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
                            self.viewModel.apiAddChatMedia()
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
        return true
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }
    

}

//MARK: Extension UDF
extension MessageVC {
    
    func viewDidLoadMethod() {
        
        dataSource = MessageDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
            var frame = CGRect.zero
            frame.size.height = .leastNormalMagnitude
            tableView.tableHeaderView = UIView(frame: frame)
        }
        
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 50)
        textView.maxHeight = 80
        textView.automaticallyAdjustsScrollIndicatorInsets = true
                               
        if !receiver_profile.isEmpty {
            let strUrl = UrlProfileImage + receiver_profile
            
            let imageWidth = imageReceiverProfile.frame.size.width
            let imageHeight = imageReceiverProfile.frame.size.height
            let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)

            self.imageReceiverProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageReceiverProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            
            if !is_blocked {
                let gestureRecognizer = UITapGestureRecognizer(
                    target: self, action:#selector(handleTapForProfile))
                self.imageReceiverProfile.addGestureRecognizer(gestureRecognizer)
                self.imageReceiverProfile.isUserInteractionEnabled = true
            }
        } else {
            self.imageReceiverProfile.image = UIImage(named: "placeholder_matchuser")
        }
        
        self.labelReceiverName.text = receiver_name
       
        if is_blocked {
            callStackView.isHidden = true
            callStackViewWidthConstant.constant = 0
        } else {
            callStackView.isHidden = false
            callStackViewWidthConstant.constant = 110
        }
        
        changeUserStatus()
        
        reloadButton()
    }
    
    @objc func handleTapForProfile(gestureRecognizer: UITapGestureRecognizer) {
        viewModel.callGetUserDetailsAPI(user_id: receiver_id)
    }
    
    func changeUserStatus() {
        if is_blocked {
            self.labelReceiverStatus.text = ""
            self.labelOnlineYConstant.constant = 0
        } else {
            if self.recevier_chat_status == "1"  {
                if self.receiver_is_online == "1" {
                    self.labelReceiverStatus.text = Constants_Message.title_online_text
                    self.labelOnlineYConstant.constant = -10
                } else {
                    self.labelReceiverStatus.text = ""
                    self.labelOnlineYConstant.constant = 0
                }
            } else {
                
                if self.receiver_is_last_seen_enable == "1" {
                    if receiver_last_seen == "0000-00-00 00:00:00" {
                        self.labelReceiverStatus.text = ""
                        self.labelOnlineYConstant.constant = 0
                    } else {
                        
                        if getChatDateFromServerForLastSeen1(strDate: self.receiver_last_seen).isEmpty {
                            self.labelReceiverStatus.text = ""
                            self.labelOnlineYConstant.constant = 0
                        } else {
                            
                            self.labelOnlineYConstant.constant = -10
                            self.labelReceiverStatus.text = "\(Constants_Message.title_active_text) \(getChatDateFromServerForLastSeen1(strDate: self.receiver_last_seen))"
                        }
                    }
                } else {
                    self.labelReceiverStatus.text = ""
                    self.labelOnlineYConstant.constant = 0
                }
            }
        }
       
    }
    
    func reloadButton() {
        if is_SendText {
            viewSendButton.isHidden = false
            stackView.isHidden = true
            buttonSend.isHidden = false
            sendViewWidthConstant.constant = 50
        } else {
            viewSendButton.isHidden = true
            stackView.isHidden = false
            buttonSend.isHidden = true
            sendViewWidthConstant.constant = 120
        }
    }
}

//MARK: - UITextView Delegate
extension MessageVC:UITextViewDelegate {
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.color_MediumGrey {
            textView.text = nil
            textView.textColor = Constants.color_DarkGrey
            is_SendText = true
        }
        reloadButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants_Message.title_textview_placeholder
            textView.textColor = Constants.color_MediumGrey
            viewModel.setMessageText(value: "")
            is_SendText = false
        }
        reloadButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.setMessageText(value: (textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
        viewModel.setMessageType(value: "\(enumMessageType.text.rawValue)")
        viewModel.setMessageStatus(value: "\(enumMessageStatus.notDelivered.rawValue)")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Socket  Delegate
extension MessageVC: SocketIOHandlerDelegate {
    
    func connectionStatus(status: SocketIOStatus) {
    }
    
    func reloadMessagesStatus() {
        dataSource!.reloadMessagesFromLocal()
    }
    
    func reloadMessages() {
        viewModel.setMessageText(value: "")
        self.dataSource!.reloadMessagesFromLocal()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            let dict:NSMutableDictionary = NSMutableDictionary()
            dict.setValue("\(self.sender_id)", forKey: "receiver_id")
            dict.setValue("0", forKey: "message_id")
            dict.setValue("\(self.receiver_id)", forKey: "sender_id")
            dict.setValue("\(enumMessageStatus.read.rawValue)", forKey: "message_status")
            APP_DELEGATE.socketIOHandler?.updateMessageStatus(data: dict)            
        }
    }
    
    func InitialMessage(array: [CDMessage]) {
        dataSource!.reloadMessagesFromLocal()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            let dict:NSMutableDictionary = NSMutableDictionary()
            dict.setValue("\(self.sender_id)", forKey: "receiver_id")
            dict.setValue("0", forKey: "message_id")
            dict.setValue("\(self.receiver_id)", forKey: "sender_id")
            dict.setValue("\(enumMessageStatus.read.rawValue)", forKey: "message_status")
            APP_DELEGATE.socketIOHandler?.updateMessageStatus(data: dict)
        }
        
    }
      
    
    func reloadUserstatus(user_id: String, onlineStatus: String, lastSeen: String) {
        let strPredicate = NSString(format: "(senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d)",sender_id!,receiver_id,receiver_id,sender_id!)
        let arr = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
        
        if arr.count > 0 {
            
            let obj = arr[0]
           
            if obj.lastSeen != nil {
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.string(from: obj.lastSeen!)                
                
                receiver_last_seen = ldate
            }
            
            if obj.chatStatus != nil {
                recevier_chat_status = "\(obj.chatStatus!)"
            }
        } else {
            if (user_id == "\(receiver_id)") {
                if lastSeen != "0000-00-00 00:00:00" && !lastSeen.isEmpty {
                    receiver_last_seen = lastSeen
                }
                
                if !onlineStatus.isEmpty {
                    recevier_chat_status = "\(onlineStatus)"
                }
            }
        }
        changeUserStatus()
    }
}
