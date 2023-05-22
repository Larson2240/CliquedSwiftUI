//
//  SubmitReportReasonDataSource.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class SubmitReportReasonDataSource: NSObject, UITableViewDelegate, UITableViewDataSource  {
    
    private let viewController: SubmitReportReasonVC
    private let tableView: UITableView
    private let viewModel: SubmitReportReasonViewModel
    
    var selectedIndexPath: Int?
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SubmitReportReasonViewModel, viewController: SubmitReportReasonVC) {
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
        tableView.registerNib(nibNames: [ReportReasonCell.identifier, NoDataFoundCell.identifier])
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.setupPullToRefresh()
        }
    }
    
    //MARK: Pull To Refresh
    func setupPullToRefresh() {
        print("setupPullToRefresh")
        viewController.pullToRefreshHeaderSetUpForTableview(tableview: tableView, strStatus: "") { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.setIsRefresh(value: true)
            self.viewModel.callGetReportListAPI()
        }
    }
    
    //MARK: Hide header loader
    func hideHeaderLoader() {
        if viewController.isHeaderRefreshingForTableView(tableview: tableView) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.mj_header!.endRefreshing(completionBlock: { })
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.isCheckEmptyData() {
            return UITableView.automaticDimension
        } else {
            return tableView.frame.size.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isCheckEmptyData() {
            viewController.buttonNext.isHidden = true
            return 1
        } else {
            if viewModel.getIsDataLoad() {
                viewController.buttonNext.isHidden = false
                return viewModel.getNumberOfReport()
            } else {
                viewController.buttonNext.isHidden = true
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isCheckEmptyData() {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundCell.identifier) as! NoDataFoundCell
            cell.selectionStyle = .none
            cell.labelNoDataFound.text = Constants.label_noDataFound
            tableView.isScrollEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportReasonCell.identifier) as! ReportReasonCell
            cell.selectionStyle = .none
            
            if viewModel.getIsDataLoad() {
                cell.hideAnimation()
                viewController.labelReasonTitle.hideSkeleton()
            } else {
                viewModel.setIsDataLoad(value: false)
                cell.layoutIfNeeded()
                return cell
            }
            
            let reportData = viewModel.getReportsData(at: indexPath.row)
            cell.labelReportReasonText.text = reportData.reasonTitle
            
            if Int(viewModel.getReportReasonId()) == reportData.id {
                cell.imageviewSelectIcon.isHidden = false
            } else {
                cell.imageviewSelectIcon.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.getNumberOfReport() != 0 {
            let reportData = viewModel.getReportsData(at: indexPath.row)
            self.viewModel.setReportReasonId(value: "\(reportData.id ?? 0)")
            tableView.reloadData()
        }
    }
}

