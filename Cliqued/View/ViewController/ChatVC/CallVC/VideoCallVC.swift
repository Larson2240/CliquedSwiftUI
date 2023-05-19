//
//  VideoCallVC.swift
//  Cliqued
//
//  Created by C100-132 on 23/02/23.
//

import UIKit
import TwilioVideo
import SDWebImage
import Alamofire
import SwiftyJSON
import CallKit
import SocketIO

class VideoCallVC: UIViewController {    
    
    //MARK: - IBOutlet
    @IBOutlet var buttomMic: UIButton!
    @IBOutlet var buttonCall: UIButton!
    @IBOutlet var buttonVideoCamera: UIButton!
    @IBOutlet var buttonSwapCamera: UIButton!
    @IBOutlet var labelName: UILabel! {
        didSet {
            labelName.textColor = Constants.color_white
            labelName.font = CustomFont.THEME_FONT_Book(14)
        }
    }
    @IBOutlet var labelStatus: UILabel! {
        didSet {
            labelStatus.textColor = Constants.color_white
            labelStatus.font = CustomFont.THEME_FONT_Medium(12)
        }
    }
    @IBOutlet var viewSmallScreenVideo: VideoView!{
        didSet{
            viewSmallScreenVideo.layer.cornerRadius = 10.0
            viewSmallScreenVideo.layer.borderWidth = 2.0
            viewSmallScreenVideo.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet var otherUserView: UIView!    
    @IBOutlet var imageOtherUserProfile: UIImageView! {
        didSet {
            imageOtherUserProfile.layer.cornerRadius = imageOtherUserProfile.frame.height / 2
            imageOtherUserProfile.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var buttonSpeakerVoice: UIButton!
    
    
    //MARK: - Variable
    var dataSource : VideoCallDataSource?
    var viewModel = VideoCallViewModel()    
   
    var room: Room?
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    var remoteView: VideoView?
    var accessToken : String = ""
    var roomName = ""
    var isCalling = false
    var timer : Timer?
    var seconds = 0
    var minute = 0
    var hours = 0
    var totalSec = "00"
    var totalMin = "00"
    var totalHo = "00"
    var timerCallDeclined : Timer?
    var sender_id = ""
    var receiver_id = ""
    var is_incomingCall = false
    var callStatus = ""
    var userName = ""
    var is_audioCall = false
    var isAudioRecordingGranted: Bool = false
    var textLog = TextLog()
    var is_loudSpeaker = false
    
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
   
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = VideoCallDataSource(viewModel: viewModel, viewController: self)
        
        APP_DELEGATE.socketIOHandler?.delegate = self
        check_record_permission()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewDidLoadMethod()
        }
    }
    
    func viewDidLoadMethod() {
        labelName.text = userName
        self.navigationController?.setNavigationBarHidden(true, animated: true)
                
        if is_audioCall {
            buttonSpeakerVoice.isHidden = false
            is_loudSpeaker = false
            APP_DELEGATE.audioDevice.block = {
                do {
                    DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()

                    try APP_DELEGATE.audioSession.setMode(.voiceChat)
                } catch let error as NSError {
                    print("Fail: \(error.localizedDescription)")
                }
            }
            APP_DELEGATE.audioDevice.block();
        } else {
            buttonSpeakerVoice.isHidden = true
            APP_DELEGATE.audioDevice.block = {
                do {
                    DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()

                    try APP_DELEGATE.audioSession.setMode(.videoChat)
                } catch let error as NSError {
                    print("Fail: \(error.localizedDescription)")
                }
            }
            APP_DELEGATE.audioDevice.block();
        }
        
        self.startPreview()
        self.connectToARoom()
        setUpNotification()
    }
    
    //MARK: - Notification Center Methods
    func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(EndCall), name: .endCall, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RejectCall), name: .rejectCall, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateName), name: .updateName, object: nil)
    }
    
    @objc func UpdateName() {
        labelName.text = Calling.receiver_name
    }

    @objc func EndCall() {
        callStatus = enumCallStatus.ended.rawValue
        APP_DELEGATE.isCallOn = false
        
        if room == nil {
            self.navigationController?.popViewController(animated: true)
        }
        
        room?.disconnect()
    }
    
    @objc func RejectCall() {
        APP_DELEGATE.isCallOn = false
        callStatus = enumCallStatus.rejected.rawValue
        
        if room == nil {
            self.navigationController?.popViewController(animated: true)
        }
        
        room?.disconnect()
    }
    
    //MARK: - Button Action
    @IBAction func buttonEndCall(_ sender: UIButton) {
        APP_DELEGATE.isCallOn = false
        callStatus = enumCallStatus.cut.rawValue
        
        let data = NSMutableDictionary()
        if((Calling.is_host == "1") && (Calling.call_status == enumCallStatus.calling.rawValue)) {
            data["call_start_time"] = ""
        } else {
            data["call_start_time"] = Calling.call_start_time
        }
        
        data["call_id"] = Calling.call_id
        data["call_status"] = callStatus
        data["call_end_time"] = Date().localToUTC(format: "yyyy-MM-dd hh:mm:ss")
        data["receiverId"] = Constants.loggedInUser?.id ?? 0
        data["is_privateRoom"] = Calling.is_privateRoom
        data["is_host"] = Calling.is_host
        data["room_name"] = Calling.room_Name
        data["is_audio_call"] = Calling.is_audio_call
        data["room_sid"] = Calling.room_sid
        data["voipToken"] = (UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "")
        data["uuid"] = Calling.uuid
        data["call_duration"] = self.labelStatus.text == "Connecting..." ? "00:00:00" : self.labelStatus.text?.trimmingCharacters(in: .whitespaces)
        
        APP_DELEGATE.socketIOHandler?.updateCallStatusParticipants(data: data, response: {
            APP_DELEGATE.isCallOn = false
        }, error: {
            
        })
        
        if room == nil {
            self.navigationController?.popViewController(animated: true)
        }
        
        room?.disconnect()
    }
    
    @IBAction func buttonSpeakerAction(_ sender: UIButton) {
        if is_loudSpeaker {
            is_loudSpeaker = false
            APP_DELEGATE.audioDevice.block = {
                do {
                    DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()

                    try APP_DELEGATE.audioSession.setMode(.voiceChat)
                } catch let error as NSError {
                    print("Fail: \(error.localizedDescription)")
                }
            }
            APP_DELEGATE.audioDevice.block();
        } else {
            is_loudSpeaker = true
            APP_DELEGATE.audioDevice.block = {
                do {
                    DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()

                    try APP_DELEGATE.audioSession.setMode(.videoChat)
                } catch let error as NSError {
                    print("Fail: \(error.localizedDescription)")
                }
            }
            APP_DELEGATE.audioDevice.block();
        }
        
        if (is_loudSpeaker == false) {
            self.buttonSpeakerVoice.setImage(UIImage(named: "ic_loud_speaker"), for: .normal)
        } else {
            self.buttonSpeakerVoice.setImage(UIImage(named: "ic_mute_speaker"), for: .normal)
        }
    }    
    
    @IBAction func buttonSwipeCameraAction(_ sender: UIButton) {
        var newDevice: AVCaptureDevice?

        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }

            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                       
                    } else {
                        self.viewSmallScreenVideo.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonVideoCallAction(_ sender: UIButton) {
    }
    
    @IBAction func buttonMicAction(_ sender: UIButton) {
        if (self.localAudioTrack != nil) {
          
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
          
            
            // Update the button title
            if (self.localAudioTrack?.isEnabled == false) {
                self.buttomMic.setImage(UIImage(named: "img_micMute"), for: .normal)
            } else {
                self.buttomMic.setImage(UIImage(named: "img_mic_live"), for: .normal)
            }
        }
    }
    
    //MARK: - Set Remote Video View
    func setupRemoteVideoView() {
        // Creating `VideoView` programmatically
        if (is_audioCall == false) {
            self.remoteView = VideoView(frame: CGRect.zero, delegate: self)

            self.otherUserView.addSubview(remoteView!)
            
            if self.timer == nil {
                self.setCallTimer(incoming: false)
            }
            
            // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
            // scaleAspectFit is the default mode when you create `VideoView` programmatically.
            self.remoteView!.contentMode = .scaleAspectFit;

            let centerX = NSLayoutConstraint(item: self.remoteView!,
                                             attribute: NSLayoutConstraint.Attribute.centerX,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self.otherUserView,
                                             attribute: NSLayoutConstraint.Attribute.centerX,
                                             multiplier: 1,
                                             constant: 0);
            self.view.addConstraint(centerX)
            let centerY = NSLayoutConstraint(item: self.remoteView!,
                                             attribute: NSLayoutConstraint.Attribute.centerY,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self.otherUserView,
                                             attribute: NSLayoutConstraint.Attribute.centerY,
                                             multiplier: 1,
                                             constant: 0);
            self.view.addConstraint(centerY)
            let width = NSLayoutConstraint(item: self.remoteView!,
                                           attribute: NSLayoutConstraint.Attribute.width,
                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                           toItem: self.otherUserView,
                                           attribute: NSLayoutConstraint.Attribute.width,
                                           multiplier: 1,
                                           constant: 0);
            self.view.addConstraint(width)
            let height = NSLayoutConstraint(item: self.remoteView!,
                                            attribute: NSLayoutConstraint.Attribute.height,
                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                            toItem: self.otherUserView,
                                            attribute: NSLayoutConstraint.Attribute.height,
                                            multiplier: 1,
                                            constant: 0);
            self.view.addConstraint(height)
        } else {
            if self.timer == nil {
                self.setCallTimer(incoming: false)
            }
        }
    }
    
    //MARK: - Connect To Room
    func connectToARoom() {
               // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use Adpative Simulcast by setting builer.videoEncodingMode to .auto if preferredVideoCodec is .auto (default). The videoEncodingMode API is mutually exclusive with existing codec management APIs EncodingParameters.maxVideoBitrate and preferredVideoCodecs
            
            if self.is_audioCall == false {
                
                let preferredVideoCodec = Settings.shared.videoCodec
                if preferredVideoCodec == .auto {
                    builder.videoEncodingMode = .auto
                } else if let codec = preferredVideoCodec.codec {
                    builder.preferredVideoCodecs = [codec]
                }
                
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }

            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = self.roomName
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
               
        self.showRoomUI(inRoom: true)
    }
    
    //MARK: - Set Timer in Call
    func setCallTimer(incoming:Bool) {
        let difference = Calendar.current.dateComponents([.second], from: (Date()), to: Date())
        let formattedString = String(format: "%02ld", difference.second!)
        self.hours = self.secondsToHoursMinutesSeconds(seconds: (Int(formattedString ) ?? 0)).0
        self.minute = self.secondsToHoursMinutesSeconds(seconds: (Int(formattedString ) ?? 0)).1
        self.seconds = self.secondsToHoursMinutesSeconds(seconds: (Int(formattedString ) ?? 0)).2
        self.runTimer()
    }
    
    func runTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 59 {
            minute += 1
            totalMin = String(format: "%02i", minute) //+ ":"
            if(minute == 60) {
                hours += 1
                totalHo = String(format: "%02i", hours) //+ ":"
            }
            seconds = 0
            totalSec = String(format: "%02i", seconds)
        } else {
            seconds += 1
            totalSec = String(format: "%02i", seconds)
        }
        self.labelStatus.text = totalHo + ":" + totalMin + ":" + totalSec
        
    }
    
    // MARK: - Private
    func startPreview() {
       
        if (is_audioCall == false) {
            self.viewSmallScreenVideo.isHidden = false
            self.buttonSwapCamera.isHidden = false
            self.imageOtherUserProfile.isHidden = true
            let frontCamera = CameraSource.captureDevice(position: .front)
            let backCamera = CameraSource.captureDevice(position: .back)

            if (frontCamera != nil || backCamera != nil) {

                let options = CameraSourceOptions { (builder) in
                    if #available(iOS 13.0, *) {
                        // Track UIWindowScene events for the key window's scene.
                        // The example app disables multi-window support in the .plist (see UIApplicationSceneManifestKey).
                        builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
                    }
                }
                // Preview our local camera track in the local video preview view.
                camera = CameraSource(options: options, delegate: self)
                localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")

                // Add renderer to video track for local preview
                localVideoTrack!.addRenderer(viewSmallScreenVideo as! VideoRenderer)

                if (frontCamera != nil && backCamera != nil) {
                    // We will flip camera on tap.
    //                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.flipCamera))
    //                self.viewSmallScreenVideo.addGestureRecognizer(tap)
                }

                camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        
                    } else {
                        self.viewSmallScreenVideo.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
            else {
                
            }
        } else {
            self.viewSmallScreenVideo.isHidden = true
            self.buttonSwapCamera.isHidden = true
            self.imageOtherUserProfile.isHidden = false
            
            let strUrl = UrlProfileImage + Calling.otherUserProfile
            let baseTimbThumb = "\(URLBaseThumb)w=300&h=300&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)

            self.imageOtherUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageOtherUserProfile.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, context: nil)
        }
    }
    
    func prepareLocalMedia() {
     
        // We will share local audio and video when we connect to the Room.

        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack(options: nil, enabled: true, name: "Microphone")

            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }

            // Create a video track which captures from the camera.
            if (localVideoTrack == nil) {
                self.startPreview()
            }
   }

    // Update our UI based upon if we are in a Room or not
    func showRoomUI(inRoom: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = inRoom

        // Show / hide the automatic home indicator on modern iPhones.
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                setupRemoteVideoView()
                subscribedVideoTrack.addRenderer(self.remoteView!)
                self.remoteParticipant = participant
                return true
            }
        }
        return false
    }

    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }

    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    
    func check_record_permission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            break
        case AVAudioSession.RecordPermission.denied:
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                    } else {
                    }
            })
            break
        default:
            break        
       }
    }
    
    func showSettingsAlertForAudio() {
        if isAudioRecordingGranted {
        } else {
            alertCustom(btnNo: Constants_Message.cancel_title, btnYes: Constants_Message.open_setting_title, title: "", message: Constants_Message.open_settin_in_device_text) {
                userDefaults.set(true, forKey: "go_setting")
                 UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
    }
}

// MARK: - RoomDelegate
extension VideoCallVC : RoomDelegate {
    func roomDidConnect(room: Room) {
              
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
                  
            if !is_incomingCall {
                
                let dict:NSMutableDictionary = NSMutableDictionary()
                dict.setValue(sender_id, forKey: "host_user_id")
                dict.setValue(receiver_id, forKey: "receiver_id")
                dict.setValue(roomName, forKey: "room_name")
                dict.setValue(is_audioCall == true ? "0" : "1", forKey: "is_video_call")
                dict.setValue(is_audioCall == true ? "\(enumMessageType.audioCall.rawValue)" : "\(enumMessageType.videoCall.rawValue)", forKey: "message_type")
                dict.setValue(randomString(length: 7), forKey: "unique_message_id")
                dict.setValue("\(enumCallStatus.calling.rawValue)", forKey: "call_status")
                dict.setValue(room.sid, forKey: "room_sid")
                dict.setValue("1", forKey: "room_type")
                dict.setValue(accessToken, forKey: "access_token")
                dict.setValue(room.uuid, forKey: "uuid")
                
                APP_DELEGATE.socketIOHandler?.VideoCallCreateRoom(data: dict, response: {
                    APP_DELEGATE.isCallOn = true
                    for remoteParticipant in room.remoteParticipants {
                       
                        remoteParticipant.delegate = self
                    }
                }, error: {
                    print("error")
                })
            } else {
                                              
                let data = NSMutableDictionary()
                data["call_status"] = enumCallStatus.received.rawValue
                data["call_start_time"] = Calling.call_start_time
                data["call_end_time"] = ""
                data["call_id"] = Calling.call_id
                data["receiverId"] = (Constants.loggedInUser?.id)
                data["is_privateRoom"] = Calling.is_privateRoom
                data["is_host"] = Calling.is_host
                data["is_audio_call"] = Calling.is_audio_call
                data["room_sid"] = Calling.room_sid
                data["voipToken"] = (UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "")
                data["uuid"] = Calling.uuid
                data["call_duration"] = self.labelStatus.text == "\(Constants_Message.title_connecting_text)" ? "00:00:00" : self.labelStatus.text?.trimmingCharacters(in: .whitespaces)
                
                APP_DELEGATE.socketIOHandler?.updateCallStatusParticipants(data: data, response: {
                    APP_DELEGATE.isCallOn = true
                    
                    for remoteParticipant in room.remoteParticipants {
                        remoteParticipant.delegate = self
                    }
                }, error: {
                    print("error")
                })
            }
          
    }

    func roomDidDisconnect(room: Room, error: Error?) {
             
        callStatus = enumCallStatus.ended.rawValue
        
        let data = NSMutableDictionary()
        
        APP_DELEGATE.providerDelegate.Providerinvalide(uuid: UUID())
        if APP_DELEGATE.socketIOHandler?.isJoinSocket == true {
            self.cleanupRemoteParticipant()
            self.room = nil
            
            self.showRoomUI(inRoom: false)
        }
        
        if !self.is_incomingCall {
           
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is VideoCallVC {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else {
           
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is VideoCallVC {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        if APP_DELEGATE.isCallOn {
            
            if((Calling.is_host == "1") && (Calling.call_status == enumCallStatus.calling.rawValue)) {
                data["call_start_time"] = ""
            } else {
                data["call_start_time"] = Calling.call_start_time
            }
            
            data["call_id"] = Calling.call_id
            data["call_status"] = callStatus
            data["call_end_time"] = Date().localToUTC(format: "yyyy-MM-dd hh:mm:ss")
            data["receiverId"] = Constants.loggedInUser?.id ?? 0
            data["is_privateRoom"] = Calling.is_privateRoom
            data["is_host"] = Calling.is_host
            data["room_name"] = Calling.room_Name
            data["is_audio_call"] = Calling.is_audio_call
            data["room_sid"] = Calling.room_sid
            data["voipToken"] = (UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "")
            data["uuid"] = Calling.uuid
            data["call_duration"] = self.labelStatus.text == "Connecting..." ? "00:00:00" : self.labelStatus.text?.trimmingCharacters(in: .whitespaces)
           
            APP_DELEGATE.socketIOHandler?.updateCallStatusParticipants(data: data, response: {
                
                APP_DELEGATE.isCallOn = false
            }, error: {
                
            })
        }
    }

    func roomDidFailToConnect(room: Room, error: Error) {
        self.room = nil
        
        self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        if error != nil {
            room.disconnect()
        }
    }

    func roomDidReconnect(room: Room) {
     
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
       // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        participant.delegate = self
        
        if (is_audioCall == true) {
            if self.timer == nil {
                self.setCallTimer(incoming: false)
            }
        }
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
      
        if room.remoteParticipants.count == 0 {
            room.disconnect()
        }
        
        if remoteParticipant == participant {
            self.cleanupRemoteParticipant()
        }
        
        callStatus = enumCallStatus.ended.rawValue
        
        let data = NSMutableDictionary()
        
        APP_DELEGATE.providerDelegate.Providerinvalide(uuid: UUID())
        APP_DELEGATE.isCallOn = false
        if APP_DELEGATE.socketIOHandler?.isJoinSocket == true {
            self.cleanupRemoteParticipant()
            self.room = nil
            
            self.showRoomUI(inRoom: false)
        }
        
        if !self.is_incomingCall {
           
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is VideoCallVC {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else {
           
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is VideoCallVC {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        if((Calling.is_host == "1") && (Calling.call_status == enumCallStatus.calling.rawValue)) {
            data["call_start_time"] = ""
        } else {
            data["call_start_time"] = Calling.call_start_time
        }
        
        data["call_id"] = Calling.call_id
        data["call_status"] = callStatus
        data["call_end_time"] = Date().localToUTC(format: "yyyy-MM-dd hh:mm:ss")
        data["receiverId"] = Constants.loggedInUser?.id ?? 0
        data["is_privateRoom"] = Calling.is_privateRoom
        data["is_host"] = Calling.is_host
        data["room_name"] = Calling.room_Name
        data["is_audio_call"] = Calling.is_audio_call
        data["room_sid"] = Calling.room_sid
        data["voipToken"] = (UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "")
        data["uuid"] = Calling.uuid
        data["call_duration"] = self.labelStatus.text == "Connecting..." ? "00:00:00" : self.labelStatus.text?.trimmingCharacters(in: .whitespaces)
        
        APP_DELEGATE.socketIOHandler?.updateCallStatusParticipants(data: data, response: {
            
        }, error: {
            
        })
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

// MARK: - RemoteParticipantDelegate
extension VideoCallVC : RemoteParticipantDelegate {

    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        if (self.remoteParticipant == nil) {
            if (is_audioCall == false) {
                _ = renderRemoteParticipant(participant: participant)
            }
        }
    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
       
        if self.remoteParticipant == participant {
            if (is_audioCall == false) {
                cleanupRemoteParticipant()
            }

            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.firstIndex(of: participant) {
                remainingParticipants.remove(at: index)
                if (is_audioCall == false) {
                    renderRemoteParticipants(participants: remainingParticipants)
                }
            }
        }
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        
        if (is_audioCall == true) {
            if self.timer == nil {
                self.setCallTimer(incoming: false)
            }
            
            self.imageOtherUserProfile.isHidden = false
            
            let strUrl = UrlProfileImage + Calling.otherUserProfile
            let baseTimbThumb = "\(URLBaseThumb)w=300&h=300&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)

            self.imageOtherUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageOtherUserProfile.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, context: nil)
        }
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
      
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
      
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
       
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
      
    }
}

// MARK: - VideoViewDelegate
extension VideoCallVC : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK: - CameraSourceDelegate
extension VideoCallVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        
    }
}

//MARK: - Socket  Delegate
extension VideoCallVC: SocketIOHandlerDelegate {
    
    func connectionStatus(status: SocketIOStatus) {
    }
    
    func reloadMessages() {
       
    }
    
    func InitialMessage(array: [CDMessage]) {
        
    }
    
    func reloadUserstatus(user_id: String, onlineStatus: String, lastSeen: String) {
        
    }
}
