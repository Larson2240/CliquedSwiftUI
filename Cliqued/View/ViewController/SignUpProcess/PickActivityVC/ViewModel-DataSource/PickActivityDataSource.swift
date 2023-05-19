//
//  PickActivityDataSource.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit
import SDWebImage
import SkeletonView

class PickActivityDataSource: NSObject {
    
    private let viewController: PickActivityVC
    private let collectionView: UICollectionView
    private let viewModel: PickActivityViewModel
    
    //MARK:- Init
    init(viewController: PickActivityVC, collectionView: UICollectionView, viewModel: PickActivityViewModel) {
        self.viewController = viewController
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        setupCollectionView()
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
    }
    
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [ActivityCVCell.identifier, NoDataFoundCVCell.identifier])
        collectionView.reloadData()
        self.setupPullToRefresh()
    }
    
    //MARK: Pull To Refresh
    func setupPullToRefresh() {
        print("setupPullToRefresh")
        viewController.pullToRefreshHeaderSetUpForCollectionview(collectionview: collectionView, strStatus: "") {
            self.viewModel.setIsRefresh(value: true)
            self.viewModel.callGetActivityDataAPI()
            if !self.viewController.isFromEditProfile {
                self.viewModel.removeAllSelectedCategoryId()
            }
        }
    }
    
    //MARK: Hide header loader
    func hideHeaderLoader() {
        if viewController.isHeaderRefreshingForCollectionview(collectionview: collectionView) {
            DispatchQueue.main.async {
                self.collectionView.mj_header!.endRefreshing(completionBlock: { })
            }
        }
    }
    
}
//MARK: Extension UICollectionview
extension PickActivityDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !viewModel.isCheckEmptyData() {
            let cellWidth = (collectionView.frame.size.width) / 2
            let height = cellWidth + (cellWidth * 0.2)
            return CGSize(width: cellWidth, height: height)
            
        } else {
            let cellWidth = collectionView.frame.size.width
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if viewModel.isCheckEmptyData() {
            viewController.buttonContinue.isHidden = true
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                viewController.buttonContinue.isHidden = false
                return viewModel.getNumberOfActivity()
            } else {
                viewController.buttonContinue.isHidden = true
                return 10
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isCheckEmptyData() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataFoundCVCell", for: indexPath) as! NoDataFoundCVCell
            cell.labelNoDataFound.text = Constants.label_noDataFound
            collectionView.isScrollEnabled = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCVCell", for: indexPath) as! ActivityCVCell
            cell.setLabelFontSizeAsPerScreen(size: 14)
            
            if viewModel.getIsDataLoad() {
                cell.hideAnimation()
                viewController.hideAnimation()
            } else {
                viewModel.setIsDataLoad(value: false)
                cell.layoutIfNeeded()
                return cell
            }
            
            let activityData = viewModel.getActivityData(at: indexPath.item)
            cell.labelActivityName.text = activityData.title
            
            let strUrl = UrlActivityImage + (activityData.image ?? "")
            let imageWidth = cell.imageviewActivity.frame.size.width
            let imageHeight = cell.imageviewActivity.frame.size.height
            let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)
            cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_activity"), options: .refreshCached, context: nil)
            
            if viewModel.getSelectedCategoryId().firstIndex(where: { $0 == activityData.id}) != nil {
                cell.imageviewAlpha.isHidden = false
                cell.imageviewSelectedIcon.isHidden = false
            } else {
                cell.imageviewAlpha.isHidden = true
                cell.imageviewSelectedIcon.isHidden = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.getNumberOfActivity() != 0 {
            let activityData = viewModel.getActivityData(at: indexPath.item)
            
            if viewModel.getSelectedCategoryId().contains(where: {$0 == activityData.id}) {
                if let index = viewModel.getSelectedCategoryId().firstIndex(where: {$0 == activityData.id}) {
                    viewModel.removeSelectedCategoryId(at: index)
                    if viewController.isFromEditProfile {
                        if viewModel.getAllSelectedActivity().contains(where: {$0.activityCategoryId == "\(activityData.id ?? 0)"}) == true {
                            viewModel.setDeletedActivityIds(value: activityData.id ?? 0)
                        }
                    }
                }
            } else {
                viewModel.setSelectedCategoryId(value: activityData.id ?? 0)
                if let index = viewModel.getDeletedActivityIds().firstIndex(where: {$0 == activityData.id ?? 0}) {
                    viewModel.removeDeletedActivityIds(at: index)
                }
            }
            let indexPath = IndexPath(item: indexPath.item, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
