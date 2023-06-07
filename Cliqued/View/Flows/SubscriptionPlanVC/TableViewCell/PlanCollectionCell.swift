//
//  PlanCollectionCell.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//

import UIKit

class PlanCollectionCell: UITableViewCell {

    @IBOutlet weak var collectionviewPlans: UICollectionView!
    
    var arrayOfPlans = [SubscriptionPlanClass]()
    var isDataLoad: Bool = false
    var selectedCellIndex: Int?
    var callbackSelectedPlan: ((_ objData: SubscriptionPlanClass) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionviewPlans.delegate = self
        self.collectionviewPlans.dataSource = self
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionviewPlans.backgroundColor = .clear
        registerCollectionCell()
    }
    
    func registerCollectionCell() {
        collectionviewPlans.registerNib(nibNames: [SubscriptionPlanBestValueCVCell.identifier, SubscriptionNormalPlanCVCell.identifier])
        collectionviewPlans.reloadData()
    }
    
}
extension PlanCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 3
        return CGSize(width: cellWidth, height: 175)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionPlanBestValueCVCell", for: indexPath) as! SubscriptionPlanBestValueCVCell
        
        let planDetails = arrayOfPlans[indexPath.item]
        
        if planDetails.isBestPlan == "1" {
            cell.setupBestValuePlanCell()
        } else {
            cell.setupNormalPlanCell()
        }
        
//        if selectedCellIndex == indexPath.row {
//            if planDetails.isBestPlan == "1" {
//                cell.viewMain.transform = .init(scaleX: 0.95, y: 0.95)
//            } else {
//                cell.viewSubview.transform = .init(scaleX: 0.95, y: 0.95)
//                cell.viewSubview.backgroundColor = Constants.color_white
//                cell.viewSubview.layer.borderWidth = 3.0
//            }
//        } else {
//            cell.viewMain.transform = .identity
//            cell.viewSubview.transform = .identity
//        }
        
        cell.labelMonthValue.text = planDetails.planDuration
        cell.labelPlanPrice.text = planDetails.price
        cell.labelPlanName.text = "\(planDetails.price ?? "")/month"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let planDetails = arrayOfPlans[indexPath.item]
        callbackSelectedPlan?(planDetails)
    }
    
    
}
