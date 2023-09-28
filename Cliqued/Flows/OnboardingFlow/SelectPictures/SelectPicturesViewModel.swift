//
//  SelectPicturesViewModel.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.05.2023.
//

import Combine
import Photos
import TLPhotoPicker

struct ProfileMedia: Equatable, Identifiable {
    var id = UUID()
    
    var image: UIImage?
    var thumbnail: UIImage?
    var mediaType: Int?  //0 - Image, 1 - Video
    var videoURL: URL?
    var serverURL: URL?
    var isEditProfile: Bool = false
    var serverImageId: Int?
}

final class SelectPicturesViewModel: ObservableObject {
    @Published var arrayOfSelectedImages = [ProfileMedia]()
    var arrayOfDeletedImageIds = [Int]()
    var arrayOfEditedImages = [ProfileMedia]()
    var isFromEditProfile = false
    var videoURL: URL?
    var selectThumbnailImage = UIImage()
    
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
        checkPhotoLibraryPermission(completion: { [weak self] allowed in
            guard let self = self, let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
            
            if allowed {
                let photoViewController = TLPhotosPickerViewController()
                photoViewController.delegate = self
                var configure = TLPhotosPickerConfigure()
                
                if arrayOfSelectedImages.count == 0 {
                    configure.maxSelectedAssets = MaxPictureSelect
                } else {
                    configure.maxSelectedAssets = MaxPictureSelect - arrayOfSelectedImages.count
                }
                
                configure.allowedVideo = true
                configure.allowedLivePhotos = false
                configure.allowedPhotograph = true
                configure.allowedVideoRecording = true
                configure.maxVideoDuration = 15
                
                photoViewController.configure = configure
                
                rootVC.present(photoViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.alertCustom(btnNo: Constants.btn_cancel, btnYes: Constants_Message.alert_title_setting, title: "", message: Constants_Message.alert_media_setting_message) {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
    func removeImageTapped(with imageData: ProfileMedia) {
        if imageData.serverImageId != 0 {
            arrayOfDeletedImageIds.append(imageData.serverImageId ?? 0)
        }
        
        arrayOfSelectedImages.removeAll(where: { $0 == imageData })
    }
    
    private func isFaceDetected(profileImage: UIImage) -> Bool {
        let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        
        if let profileImage1 = profileImage.cgImage {
            let personciImage = CIImage(cgImage: profileImage1)
            let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
            let faces = faceDetector?.features(in: personciImage, options: imageOptions as? [String : AnyObject])
            
            if faces?.first is CIFaceFeature {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func convertThumbMail() -> UIImage {
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            selectThumbnailImage = thumbnail
            return thumbnail
        } catch let error {
            print(error.localizedDescription)
            return UIImage()
        }
    }
    
    private func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void) {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in
            guard let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString else { return }
            callBack(URL.init(string: strURL))
        })
    }
}

extension SelectPicturesViewModel: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        for i in withTLPHAssets {
            if i.phAsset?.mediaType == .image {
                let mediaSize = i.phAsset?.fileSize
                
                if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                    UIApplication.shared.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
//                                        if isFaceDetected(profileImage: i.fullResolutionImage ?? UIImage()) {
                    let selectedImage = UIImage.upOrientationImage(i.fullResolutionImage ?? UIImage())
                    arrayOfSelectedImages.append(ProfileMedia(image: selectedImage(), thumbnail: UIImage(), mediaType: 0, videoURL: nil, serverURL: nil, serverImageId: 0))
                    
                    if isFromEditProfile {
                        arrayOfEditedImages.append(ProfileMedia(image: selectedImage(), thumbnail: UIImage(), mediaType: 0, videoURL: nil, serverURL: nil, serverImageId: 0))
                    }
                    //                    } else {
                    //                        UIApplication.shared.showAlertPopup(message: Constants.validMsg_faceDetection)
                    //                    }
                }
            } else if i.phAsset?.mediaType == .video {
                let mediaSize = i.phAsset?.fileSize
                
                if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                    UIApplication.shared.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                    getUrlFromPHAsset(asset: i.phAsset!) { [weak self] url in
                        guard let self = self else { return }
                        
                        self.videoURL = url
                        let selectedImage = UIImage.upOrientationImage(i.fullResolutionImage ?? UIImage())
                        let thumbImage = self.convertThumbMail()
                        
                        self.arrayOfSelectedImages.append(ProfileMedia(image: selectedImage(), thumbnail: thumbImage, mediaType: 1, videoURL: self.videoURL, serverURL: nil, serverImageId: 0))
                        
                        if self.isFromEditProfile {
                            self.arrayOfEditedImages.append(ProfileMedia(image: selectedImage(), thumbnail: thumbImage, mediaType: 1, videoURL: self.videoURL, serverURL: nil, serverImageId: 0))
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }
}
