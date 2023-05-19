
//
//  PickSubActivityDataSource.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit
import SDWebImage

class PickSubActivityDataSource: NSObject {
    
    private let viewController: PickSubActvityVC
    private let viewModel: PickSubActivityViewModel
    private let collectionView: UICollectionView
    private var selectedItemIndex: Int?

    //MARK:- Init
    init(viewController: PickSubActvityVC, collectionView: UICollectionView, viewModel: PickSubActivityViewModel) {
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
        collectionView.registerNib(nibNames: [SubActivityCell.identifier, NoDataFoundCVCell.identifier])
        collectionView.register(UINib(nibName: "SubActivitySectionCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SubActivitySectionCell")
        collectionView.reloadData()
    }
    
}
//MARK: Extension UICollectionview
extension PickSubActivityDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if !viewModel.isCheckEmptyData() {
            return CGSize(width: collectionView.bounds.width, height: 50)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !viewModel.isCheckEmptyData() {
            let cellWidth = collectionView.frame.size.width / 2
            return CGSize(width: cellWidth, height: 50)
        } else {
            let cellWidth = collectionView.frame.size.width
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.isCheckEmptyData() {
            viewController.buttonContinue.isHidden = true
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                viewController.buttonContinue.isHidden = false
                return viewModel.getNumberOfActivity()
            } else {
                viewController.buttonContinue.isHidden = true
                return 5
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubActivitySectionCell", for: indexPath) as! SubActivitySectionCell
            headerView.backgroundColor = .clear
            
            if viewModel.getIsDataLoad() {
                headerView.hideAnimation()
                self.viewController.hideAnimation()
            } else {
                viewModel.setIsDataLoad(value: false)
                headerView.layoutIfNeeded()
                return headerView
            }
            
            let activityData = viewModel.getActivityData(at: indexPath.section)
            headerView.labelSectionTitle.text = activityData.title
            if let imagename = activityData.icon {
                headerView.buttonSectionImage.setImage(UIImage(named: "\(imagename).png"), for: .normal)
            }
//            let strUrl = UrlActivityImage + (activityData.icon ?? "")
//            let url = URL(string: strUrl)
//            headerView.buttonSectionImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            headerView.buttonSectionImage.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            return headerView
        default:
            return UIView() as! UICollectionReusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.isCheckEmptyData() {
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                let activityData = viewModel.getActivityData(at: section)
                return activityData.subCategory?.count ?? 0
            } else {
                return 4
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubActivityCell", for: indexPath) as! SubActivityCell
            
            if viewModel.getIsDataLoad() {
                cell.hideAnimation()
                self.viewController.hideAnimation()
            } else {
                viewModel.setIsDataLoad(value: false)
                cell.layoutIfNeeded()
                return cell
            }
            
            let activityData = viewModel.getActivityData(at: indexPath.section)
            let subActiviyData = activityData.subCategory?[indexPath.item]
            cell.labelSubActivityTitle.text = subActiviyData?.title
            
            if viewModel.getSelectedSubActivity().firstIndex(where: { $0.activitySubCategoryId == "\(subActiviyData?.id ?? 0)"}) != nil {
                cell.selectedCategoryUI(viewName: cell.viewMain)
            } else {
                cell.unselectedCategoryUI(viewName: cell.viewMain)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.getNumberOfActivity() != 0 {
            let activityData = viewModel.getActivityData(at: indexPath.section)
            let subActiviyData = activityData.subCategory?[indexPath.item]
            if viewModel.getSelectedSubActivity().contains(where: { $0.activityCategoryId == "\(activityData.id ?? 0)" && $0.activitySubCategoryId == "\(subActiviyData?.id ?? 0)"}) {
                if let index = viewModel.getSelectedSubActivity().firstIndex(where: { $0.activityCategoryId == "\(activityData.id ?? 0)" && $0.activitySubCategoryId == "\(subActiviyData?.id ?? 0)"}) {
                    viewModel.removeSelectedSubActivity(at: index)
                }
            } else {
                var dict = structPickSubActivityParams()
                dict.activityCategoryId = activityData.id?.description ?? ""
                dict.activitySubCategoryId = subActiviyData?.id?.description ?? ""
                viewModel.setSubActivity(value: dict)
            }
            let indexPath = IndexPath(item: indexPath.item, section: indexPath.section)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

