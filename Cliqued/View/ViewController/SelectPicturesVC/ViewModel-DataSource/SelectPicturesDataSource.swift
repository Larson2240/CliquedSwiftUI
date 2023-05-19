//
//  SelectPicturesDataSource.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import TLPhotoPicker
import Photos

class SelectPicturesDataSource: NSObject {
    
    private let viewController: SelectPicturesVC
    private let collectionView: UICollectionView
    private var selectedItemIndex: Int?
    
    struct structProfileMedia {
        var image: UIImage
        var mediaType: Int  //0 - Image, 1 - Video
        var videoURL: String
    }
    var arrayOfSelectedImages = [structProfileMedia]()
    
    //MARK:- Init
    init(collectionView: UICollectionView, viewController: SelectPicturesVC) {
        self.viewController = viewController
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
        checkPhotoLibraryPermission(completion: {(value) -> Void in
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
                photoViewController.configure = configure
                
                viewController.present(photoViewController, animated: true, completion: nil)
            } else {
                viewController.alertCustom(yesStr: "Setting", noStr: Constants.btn_cancel, title: Constants.label_appName, message: "Please Allow Access to your Photos") {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
    
}
//MARK: Extension UICollectionview
extension SelectPicturesDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 3
        return CGSize(width: cellWidth, height: 160)
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
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPictureCell", for: indexPath) as! SelectPictureCell
            let mediaData = arrayOfSelectedImages[indexPath.item]
             
            if(arrayOfSelectedImages.count > 0) {
                cell.imageview.image = mediaData.image
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
//        openTLPhotoPicker()
    }
    
    //MARK: Button Add Image and Video
    @objc func buttonAddTap(_ sender: UIButton) {
        openTLPhotoPicker()
    }
    
    //MARK: Button Cancel Selected Image and Video
    @objc func buttonCancelPictureTap(_ sender: UIButton) {
        arrayOfSelectedImages.remove(at: sender.tag)
        collectionView.reloadData()
    }
}
//MARK: Extension TLPhotoPicker
extension SelectPicturesDataSource: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        for i in withTLPHAssets{
            if i.phAsset?.mediaType == .image{
                self.arrayOfSelectedImages.append(structProfileMedia(image: i.fullResolutionImage ?? UIImage(), mediaType: 0, videoURL: ""))
            } else {
                self.arrayOfSelectedImages.append(structProfileMedia(image: i.fullResolutionImage ?? UIImage(), mediaType: 1, videoURL: ""))
            }
        }
        self.collectionView.reloadData()
        return true
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }
}
