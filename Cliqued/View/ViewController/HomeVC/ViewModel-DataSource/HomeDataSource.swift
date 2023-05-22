//
//  HomeDataSource.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import SDWebImage

class HomeDataSource: NSObject {
    
    private let viewController: HomeVC
    private let collectionView: UICollectionView
    private let viewModel: HomeViewModel
    private let vieWModelMessage: MessageViewModel
    private var selectedItemIndex: Int?
    
    //MARK:- Init
    init(viewController: HomeVC, viewModel: HomeViewModel, collectionView: UICollectionView, viewModelMessage: MessageViewModel) {
        self.viewController = viewController
        self.viewModel = viewModel
        self.vieWModelMessage = viewModelMessage
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
        collectionView.registerNib(nibNames: [ActivityCVCell.identifier, NoDataFoundCVCell.identifier])
        collectionView.reloadData()
        self.setupPullToRefresh()
    }
    
    //MARK: Pull To Refresh
    func setupPullToRefresh() {
        print("setupPullToRefresh")
        viewController.pullToRefreshHeaderSetUpForCollectionview(collectionview: collectionView, strStatus: "") { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.setIsRefresh(value: true)
            self.viewModel.callGetUserInterestedCategoryAPI()
        }
    }
    
    //MARK: Hide header loader
    func hideHeaderLoader() {
        if viewController.isHeaderRefreshingForCollectionview(collectionview: collectionView) {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.mj_header!.endRefreshing(completionBlock: { })
            }
        }
    }
    
}
//MARK: Extension UICollectionview
extension HomeDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !viewModel.isCheckEmptyData() {
            
            let cellWidth = (collectionView.frame.size.width) / 2
            let height = cellWidth + (cellWidth * 0.2)
            return CGSize(width: cellWidth, height: height)
            
//            let cellWidth = collectionView.frame.size.width / 2
//            return CGSize(width: cellWidth, height: 210)
        } else {
            let cellWidth = collectionView.frame.size.width
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if viewModel.isCheckEmptyData() {
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                return viewModel.getNumberOfCategory()
            } else {
                return 6
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
            } else {
                viewModel.setIsDataLoad(value: false)
                cell.layoutIfNeeded()
                return cell
            }
            
            let homeData = viewModel.getCategoryData(at: indexPath.item)
            cell.labelActivityName.text = homeData.title
            
            let strUrl = UrlActivityImage + (homeData.image ?? "")
            let imageWidth = cell.imageviewActivity.frame.size.width
            let imageHeight = cell.imageviewActivity.frame.size.height
            let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
            
            let url = URL(string: baseTimbThumb)
            cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_activity"), options: .refreshCached, context: nil)
            
            cell.imageviewAlpha.isHidden = true
            cell.imageviewSelectedIcon.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.getNumberOfCategory() != 0 {
            let homeactivitiesVC = HomeActivitiesVC.loadFromNib()
            let homeData = viewModel.getCategoryData(at: indexPath.item)
            homeactivitiesVC.objOfHomeCategory = homeData
            homeactivitiesVC.hidesBottomBarWhenPushed = true
            viewController.navigationController?.pushViewController(homeactivitiesVC, animated: true)
        }
    }
}
