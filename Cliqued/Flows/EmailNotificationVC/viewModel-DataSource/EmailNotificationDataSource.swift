//
//  EmailNotificationDataSource.swift
//  Cliqued
//
//  Created by C100-132 on 17/02/23.
//

import UIKit

class EmailNotificationDataSource: NSObject {
    
    private let viewController: EmailNotification
    private let viewModel: EmailNotificationViewModel
    private let tableView : UITableView
    private let preferenceOptionIds = PreferenceOptionIds()
    private let preferenceTypeIds = PreferenceTypeIds()
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: EmailNotificationViewModel, viewController: EmailNotification) {
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
    //MARK: Register Tableview cell xibs
    func registerTableCell(){
        tableView.registerNib(nibNames: [SettingsRowCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: UISwitch Action
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        let obj = viewModel.arrNotification[0].subTypes![mySwitch.tag]
        viewModel.setPreferenceId(value: "\(obj.id ?? 0)")
        if let sub_array = obj.typeOptions, sub_array.count > 0 {
            
            if value == true {
                
                let array_value = sub_array.filter({$0.typeOfOptions == preferenceOptionIds.yes})
                
                if array_value.count > 0 {
                    viewModel.setPreferenceOptionId(value: "\(array_value[0].id ?? 0)")
                }
            } else {
                let array_value = sub_array.filter({$0.typeOfOptions == preferenceOptionIds.no})
                
                if array_value.count > 0 {
                    viewModel.setPreferenceOptionId(value: "\(array_value[0].id ?? 0)")
                }
            }
        }
        viewModel.apiUpdateUserNotificationStatus()
    }
}

//MARK: UItablview Delegate Datasource
extension EmailNotificationDataSource : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.arrNotification.count > 0 {
            return viewModel.arrNotification[0].subTypes!.count
        }
        return viewModel.arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier, for: indexPath) as! SettingsRowCell
        cell.selectionStyle = .none
        cell.switchButton.isHidden = false
        cell.switchButton.tag = indexPath.row
        
        cell.switchButton.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        cell.imageviewNextArrow.isHidden = true
        cell.imageviewBottomLine.isHidden = false
        cell.labelSettingSubTitle.isHidden = true
        
        let obj = viewModel.arrNotification[0].subTypes![indexPath.row]
        
        
        
        cell.labelSettingsRowTitle.text = obj.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

