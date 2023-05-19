//
//  SubscriptionPlanDataSource.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//


import UIKit

class SubscriptionPlanDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SubscriptionPlanVC
    private let tableView: UITableView
    private let viewModel: SubscriptionPlanViewModel
    
    //MARK: Enum Section
    enum enumSubscriptionScreenRow: Int, CaseIterable {
        case subscriptionBenefitsList = 0
        case planCollection
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SubscriptionPlanViewModel, viewController: SubscriptionPlanVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    
    func registerTableCell(){
        tableView.registerNib(nibNames: [PlanBenefitsCell.identifier, PlanCollectionCell.identifier, PlanTermsConditionCell.identifier])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isCheckEmptyData() {
            tableView.isHidden = true
            return 0
        } else {
            return enumSubscriptionScreenRow.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSubscriptionScreenRow(rawValue: indexPath.row)! {
        case .subscriptionBenefitsList:
            let cell = tableView.dequeueReusableCell(withIdentifier: PlanBenefitsCell.identifier) as! PlanBenefitsCell
            cell.selectionStyle = .none
            return cell
        case .planCollection:
            let cell = tableView.dequeueReusableCell(withIdentifier: PlanCollectionCell.identifier) as! PlanCollectionCell
            cell.selectionStyle = .none
            cell.arrayOfPlans = self.viewModel.getAllPlans()
            cell.collectionviewPlans.reloadData()
            
            cell.callbackSelectedPlan = { planData in
                self.viewModel.setPlanData(value: planData)
            }
            return cell
        }
    }
}
