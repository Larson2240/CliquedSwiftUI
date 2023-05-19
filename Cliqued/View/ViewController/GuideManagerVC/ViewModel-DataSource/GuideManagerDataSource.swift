//
//  GuideManagerDataSource.swift
//  Cliqued
//
//  Created by C211 on 03/03/23.
//

import UIKit
import SDWebImage

class GuideManagerDataSource: NSObject {
    
    private let viewController: GuideManagerVC
    private let collectionView: UICollectionView
    private var selectedItemIndex: Int?
    
    //Arrays for scale 3 devices
    var arrayOfTabImages = ["hometab","hometabselected","activitytab","addactivity","editactivity","interestedcount","startdiscovery","chattab","profiletab"]
    var arrayOfActivitiesTabImages = ["addactivity","editactivity","interestedcount","startdiscovery","chattab","profiletab"]
    var arrayOfUserSwipeImages = ["userswipe","userinfo","userundo","userlike","userdontwantmeet"]
    var arrayOfActivitySwipeImages = ["activityswipe","activityinfo","activitylike","activitydontwantmeet"]
    
    //Arrays for scale 2 devices
    var arrayOfTabImagesScale2 = ["scl_hometab","scl_hometabselected","scl_activitytab","scl_addactivity","scl_editactivity","scl_interestedcount","scl_startdiscovery","scl_chattab","scl_profiletab"]
    var arrayOfActivitiesTabImagesScale2 = ["scl_addactivity","scl_editactivity","scl_interestedcount","scl_startdiscovery","scl_chattab","scl_profiletab"]
    var arrayOfUserSwipeImagesScale2 = ["scl_userswipe","scl_userinfo","scl_userundo","scl_userlike","scl_userdontwantmeet"]
    var arrayOfActivitySwipeImagesScale2 = ["scl_activityswipe","scl_activityinfo","scl_activitylike","scl_activitydontwantmeet"]
    
    //Main array
    var arrayOfTutorial = [String]()
    
    //MARK:- Init
    init(viewController: GuideManagerVC, collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
        setupDataInCollectionView()
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
    }
    
    //MARK: - Register Tableview cell xibs
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [GuideManagerCVCell.identifier])
        collectionView.reloadData()
    }
    
    func setupDataInCollectionView() {
        if UIDevice.current.hasNotch {
            if viewController.isFromUserSwipeScreen {
                arrayOfTutorial = arrayOfUserSwipeImages
            } else if viewController.isFromActivitySwipeScreen {
                arrayOfTutorial = arrayOfActivitySwipeImages
            } else if viewController.isFromActivitiesScreen {
                arrayOfTutorial = arrayOfActivitiesTabImages
            } else {
                arrayOfTutorial = arrayOfTabImages
            }
        } else {
            if viewController.isFromUserSwipeScreen {
                arrayOfTutorial = arrayOfUserSwipeImagesScale2
            } else if viewController.isFromActivitySwipeScreen {
                arrayOfTutorial = arrayOfActivitySwipeImagesScale2
            } else if viewController.isFromActivitiesScreen {
                arrayOfTutorial = arrayOfActivitiesTabImagesScale2
            } else {
                arrayOfTutorial = arrayOfTabImagesScale2
            }
        }
    }
}
//MARK: Extension UICollectionview
extension GuideManagerDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayOfTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let languagename = getLanguage()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideManagerCVCell", for: indexPath) as! GuideManagerCVCell
        cell.btnimageview.contentMode = .scaleAspectFit
        let guideData = arrayOfTutorial[indexPath.item]
        cell.btnimageview.setImage(UIImage(named: "\(languagename)_\(guideData)"), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        print(contentOffset)
        self.moveCollectionToFrame(contentOffset: contentOffset)
        if arrayOfTutorial.count - 1 == indexPath.row {
            viewController.navigationController?.popViewController(animated: false)
        }
    }
    
    //MARK: Move collectionView function
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: false)
    }
}
