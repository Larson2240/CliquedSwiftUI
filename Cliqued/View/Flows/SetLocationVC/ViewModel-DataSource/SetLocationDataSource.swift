//
//  SetLocationDataSource.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class SetLocationDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SetLocationVC
    private let tableView: UITableView
    private let viewModel: SetLocationViewModel
    
    enum enumSetLocationTableRow: Int, CaseIterable {
        case mapview = 0
        case pickDistance
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SetLocationViewModel, viewController: SetLocationVC) {
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
        tableView.registerNib(nibNames: [LocationMapCell.identifier, LocationDistanceCell.identifier])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumSetLocationTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSetLocationTableRow(rawValue: indexPath.row)! {
        case .mapview:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationMapCell.identifier) as! LocationMapCell
            cell.selectionStyle = .none
            return cell
        case .pickDistance:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationDistanceCell.identifier) as! LocationDistanceCell
            cell.selectionStyle = .none
            cell.sliderDistance.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            return cell
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        self.tableView.reloadData()
    }
}

