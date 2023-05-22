//
//  CallManager.swift
//  NeedAReader
//
//  Created by Chetan Puwar on 22/01/21.
//  Copyright © 2021 Narola. All rights reserved.
//
import AVFoundation
import CallKit
import Foundation
import UIKit

func isCallKitSupported() -> Bool {
    let userLocale = NSLocale.current
    
    guard let regionCode = userLocale.regionCode else { return false }
    
    if regionCode.contains("CN") ||
        regionCode.contains("CHN") {
        return false
    } else {
        return true
    }
}

class ProviderDelegate: NSObject {
    private var provider: CXProvider!
    
    override init() {
        provider = CXProvider(configuration: ProviderDelegate.configuration)
        super.init()
        if isCallKitSupported() {
            provider.setDelegate(self, queue: .main)
        }
    }
    
    static var configuration: CXProviderConfiguration = {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        let config = CXProviderConfiguration(localizedName: appName ?? "")
        config.supportsVideo = true
        config.maximumCallsPerCallGroup = 1
        config.maximumCallGroups = 1
        config.supportedHandleTypes = [.phoneNumber]
        return config
    }()
    
    func reportIncomingCall(
        uuid: UUID,
        callername : String,
        hasVideo: Bool = false,
        temp:callingStruct,
        completion: ((Error?) -> Void)?
    ) {
        let update = CXCallUpdate.init()
        update.remoteHandle = CXHandle.init(type: .phoneNumber, value: callername)
        update.hasVideo = !hasVideo
        update.supportsHolding = false
        
        Calling.room_sid = temp.room_sid
        Calling.room_Name = temp.room_Name
        Calling.sender_access_token  = temp.sender_access_token
        Calling.call_id = temp.callId
        Calling.is_privateRoom = temp.privateRoom
        Calling.is_host = temp.isHost
        Calling.uuid = temp.uuid
        Calling.receiver_name = temp.sender_name
        Calling.otherUserProfile = temp.sender_profile
        
        Calling.is_audio_call = temp.is_audio_call
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            completion?(error)
        }
    }
    
    func Providerinvalide(uuid: UUID) {
        provider.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
        provider.invalidate()
    }
}
// MARK: - CXProviderDelegate
extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {}
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        APP_DELEGATE.timerCallDeclined?.invalidate()
        UserDefaults.standard.set("\(action.callUUID)", forKey: USER_DEFAULT_KEYS.OLD_CALL_UUID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .incomingCall, object:nil)
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("audioSession")
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("CXEndCallAction")
        APP_DELEGATE.timerCallDeclined?.invalidate()
        RejectSessionSub(callStatus: enumCallStatus.rejected.rawValue)
        NotificationCenter.default.post(name: .rejectCall, object:nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("CXSetHeldCallAction")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("CXSetHeldCallAction")
    }
}

extension ProviderDelegate
{
    
    func RejectSessionSub(callStatus: String)
    {
        let data = NSMutableDictionary()
        APP_DELEGATE.timerCallDeclined?.invalidate()
        
        if callStatus == enumCallStatus.unanswered.rawValue {
            APP_DELEGATE.isCallOn = false
            Providerinvalide(uuid: UUID(uuidString: Calling.uuid) ?? UUID())
        } else if callStatus == enumCallStatus.ended.rawValue {
            APP_DELEGATE.isCallOn = false
            Providerinvalide(uuid: UUID(uuidString: Calling.uuid) ?? UUID())
        }
        
        data["call_status"] = callStatus
        data["call_start_time"] = ""
        data["call_end_time"] = ""
        data["call_id"] = Calling.call_id
        data["receiverId"] = Constants.loggedInUser?.id ?? 0
        data["is_privateRoom"] = Calling.is_privateRoom
        data["is_host"] = Calling.is_host
        data["room_name"] = Calling.room_Name
        data["room_sid"] = Calling.room_sid
        data["voipToken"] = (UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "")
        data["uuid"] = Calling.uuid
        data["call_duration"] = "00:00:00"
        data["is_audio_call"] = Calling.is_audio_call
        
        APP_DELEGATE.socketIOHandler?.updateCallStatusParticipants(data: data, response: {
            
        }, error: {
            
        })
        
    }
}
