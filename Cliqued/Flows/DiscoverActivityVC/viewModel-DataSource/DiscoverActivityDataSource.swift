//
//  DiscoverViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 03/02/23.
//

import UIKit
import SDWebImage

class DiscoverActivityDataSource: NSObject {
    
    private let viewController: DiscoverActivityVC
    private let collectionView: UICollectionView
    private let viewModel: DiscoverActivityViewModel
    
    //MARK:- Init
    init(collectionView: UICollectionView, viewModel: DiscoverActivityViewModel, viewController: DiscoverActivityVC) {
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
////            self.setupPullToRefresh()
////            self.setupLoadMore()
//        }
    }
    
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [YourActivityCVCell.identifier])
        collectionView.reloadData()
    }
    
//    //MARK: Pull To Refresh
//    func setupPullToRefresh() {
//        print("setupPullToRefresh")
//        viewController.pullToRefreshHeaderSetUpForCollectionview(collectionview: collectionView, strStatus: "") {
//            self.viewModel.setIsRefresh(value: true)
////            self.viewModel.setOffset(value: "0")
//            self.viewModel.callActivityListAPI()
//        }
//    }
//
//    //MARK: Load More
//    func setupLoadMore() {
//        viewController.loadMoreFooterSetUpForCollectionview(collectionview: collectionView) {
//            if self.viewController.isFooterRefreshingForCollectionView(collectionview: self.collectionView) {
//                self.collectionView.mj_footer?.endRefreshing(completionBlock: {
//                    self.viewModel.setIsRefresh(value: true)
//                    let offset = self.viewModel.arrOtherActivities.count + 1
////                    self.viewModel.setOffset(value: "\(offset)")
//                    self.viewModel.callActivityListAPI()
//                })
//            }
//        }
//    }
    
    //MARK: Hide header loader
    func hideHeaderLoader() {
        if viewController.isHeaderRefreshingForCollectionview(collectionview: collectionView) {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.mj_header!.endRefreshing(completionBlock: { })
            }
        }
    }
    
    //MARK: Hide footer loader
    func hideFooterLoader() {
        if viewController.isFooterRefreshingForCollectionView(collectionview: collectionView) {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.mj_footer!.endRefreshing(completionBlock: { })
            }
        }
    }
    
}

//MARK: Extension UICollectionview
extension DiscoverActivityDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2
        return CGSize(width: cellWidth - 5, height: 210)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if viewModel.getIsDataLoad() {
            return viewModel.arrOtherActivities.count
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourActivityCVCell.identifier, for: indexPath) as! YourActivityCVCell

        if viewModel.getIsDataLoad() {
            cell.hideAnimation()
        } else {
            viewModel.setIsDataLoad(value: false)
            cell.layoutIfNeeded()
            return cell
        }
        if viewModel.arrOtherActivities.count > 0 {
            let obj = viewModel.arrOtherActivities[indexPath.item]
            
            cell.buttonInterestedCount.isHidden = true
            cell.buttonEditActivity.isHidden = true
            
            if obj.medias.count > 0 {
                let img = obj.medias[0]
                let url = URL(string: "https://api.cliqued.app" + img.url)
                cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, context: nil)
            }
            
            cell.labelMainCategory.text = obj.title
            cell.labelSubCategory.text = obj.title
        }       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if self.viewModel.arrOtherActivities.count > 0 {
            let obj = self.viewModel.arrOtherActivities[indexPath.item]
            let otheruseractivityvc = OtherUserActivityDetailsVC.loadFromNib()
            otheruseractivityvc.activity_id = "\(self.viewModel.arrOtherActivities[indexPath.item].id ?? 0)"
            otheruseractivityvc.objActivityDetails = viewModel.arrOtherActivities[indexPath.item]
            otheruseractivityvc.hidesBottomBarWhenPushed = true
            self.viewController.navigationController?.pushViewController(otheruseractivityvc, animated: true)
        }
    }
}
