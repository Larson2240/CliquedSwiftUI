//
//  SelectPicturesDataSource.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import TLPhotoPicker
import Photos
import CoreImage
import SDWebImage

class SelectPicturesDataSource: NSObject {
    
    private let viewController: SelectPicturesVC
    private let collectionView: UICollectionView
    private let viewModel: SignUpProcessViewModel
    private var selectedItemIndex: Int?
    
    struct structProfileMedia {
        var image: UIImage?
        var thumbnail: UIImage?
        var mediaType: Int?  //0 - Image, 1 - Video
        var videoURL: URL?
        var serverURL: URL?
        var isEditProfile: Bool = false
        var serverImageId: Int?
    }
    var arrayOfSelectedImages = [structProfileMedia]()
    var arrayOfEditedImages = [structProfileMedia]()
    var arrayOfThumbnails = [UIImage]()
    var selectThumbnailImage = UIImage()
    var arrayOfDeletedImageIds = [Int]()
    var videoURL: URL?
    
    //MARK:- Init
    init(viewController: SelectPicturesVC, viewModel: SignUpProcessViewModel, collectionView: UICollectionView) {
        self.viewController = viewController
        self.viewModel = viewModel
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
    }
    
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [SelectPictureCell.identifier, AddPictureCVCell.identifier])
        collectionView.reloadData()
    }
    
    //MARK: Function
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
                
                viewController.present(photoViewController, animated: true, completion: nil)
            } else {
                viewController.alertCustom(btnNo: Constants.btn_cancel, btnYes: Constants_Message.alert_title_setting, title: "", message: Constants_Message.alert_media_setting_message) {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
    func convertThumbMail() -> UIImage {
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
    func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void) {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in
            
            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString {
                print("VIDEO URL: \(strURL)")
                callBack(URL.init(string: strURL))
            }
            
        })
    }
    
}
//MARK: Extension UICollectionview
extension SelectPicturesDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 3
        return CGSize(width: cellWidth, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(arrayOfSelectedImages.count < MaxPictureSelect) {
            return arrayOfSelectedImages.count + 1
        } else {
            return arrayOfSelectedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == arrayOfSelectedImages.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPictureCVCell", for: indexPath) as! AddPictureCVCell
            cell.imageviewAddPlaceholder.image = UIImage(systemName: "plus")
            cell.buttonAddPicture.tag = indexPath.item
            cell.buttonAddPicture.addTarget(self, action: #selector(buttonAddTap(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPictureCell", for: indexPath) as! SelectPictureCell
            let mediaData = arrayOfSelectedImages[indexPath.item]
            
            if mediaData.serverURL == nil {
                cell.imageview.image = mediaData.image
            } else {
                cell.imageview.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageview.sd_setImage(with: mediaData.serverURL, placeholderImage: UIImage(named: "placeholder_detailpage"), options: .refreshCached, context: nil)
            }
            
            if mediaData.mediaType == 1 {
                cell.imageviewVideoIcon.isHidden = false
            } else {
                cell.imageviewVideoIcon.isHidden = true
            }
            
            cell.buttonCancel.tag = indexPath.item
            cell.buttonCancel.addTarget(self, action: #selector(buttonCancelPictureTap(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == arrayOfSelectedImages.count) {
            openTLPhotoPicker()
        }
    }
    
    //MARK: Button Add Image and Video
    @objc func buttonAddTap(_ sender: UIButton) {
        openTLPhotoPicker()
    }
    
    //MARK: Button Cancel Selected Image and Video
    @objc func buttonCancelPictureTap(_ sender: UIButton) {
        let mediaData = arrayOfSelectedImages[sender.tag]
        if mediaData.serverImageId != 0 {
            self.arrayOfDeletedImageIds.append(mediaData.serverImageId ?? 0)
        }
        arrayOfSelectedImages.remove(at: sender.tag)
        collectionView.reloadData()
    }
}
//MARK: Extension TLPhotoPicker
extension SelectPicturesDataSource: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        for i in withTLPHAssets {
            if i.phAsset?.mediaType == .image {
                let mediaSize = i.phAsset?.fileSize
                
                if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                    self.viewController.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                    if isFaceDetected(profileImage: i.fullResolutionImage ?? UIImage()) {
                        let selectedImage = UIImage.upOrientationImage(i.fullResolutionImage ?? UIImage())
                        self.arrayOfSelectedImages.append(structProfileMedia(image: selectedImage(), thumbnail: UIImage(), mediaType: 0, videoURL: nil, serverURL: nil, serverImageId: 0))
                        if self.viewController.isFromEditProfile {
                            self.arrayOfEditedImages.append(structProfileMedia(image: selectedImage(), thumbnail: UIImage(), mediaType: 0, videoURL: nil, serverURL: nil, serverImageId: 0))
                        }
                        self.collectionView.reloadData()
                    } else {
                        viewController.showAlertPopup(message: Constants.validMsg_faceDetection)
                    }
                }
            } else if i.phAsset?.mediaType == .video {
              
                let mediaSize = i.phAsset?.fileSize
                
                if mediaSize ?? 0 > Float(MEDIA_SIZE) {
                    self.viewController.showAlertPopup(message: Constants_Message.validation_media_upload)
                } else {
                    getUrlFromPHAsset(asset: i.phAsset!) { [weak self] (url) in
                        guard let self = self else { return }
                        
                        self.videoURL = url
                        let selectedImage = UIImage.upOrientationImage(i.fullResolutionImage ?? UIImage())
                        let thumbImage = self.convertThumbMail()
                        self.arrayOfSelectedImages.append(structProfileMedia(image: selectedImage(), thumbnail: thumbImage, mediaType: 1, videoURL: self.videoURL, serverURL: nil, serverImageId: 0))
                        if self.viewController.isFromEditProfile {
                            self.arrayOfEditedImages.append(structProfileMedia(image: selectedImage(), thumbnail: thumbImage, mediaType: 1, videoURL: self.videoURL, serverURL: nil, serverImageId: 0))
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        return true
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }

    //MARK: Face detection function
    func isFaceDetected(profileImage: UIImage) -> Bool {
       
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
}
