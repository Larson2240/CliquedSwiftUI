//
//  LicenseDetailsDataSource.swift
//  Cliqued
//
//  Created by C211 on 27/04/23.
//

import UIKit

class LicenseDetailsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource  {
    private let viewController: LicenseDetailsVC
    private let tableView: UITableView
    private let viewModel: LicenseDetailsViewModel
    
    struct structLibraryDetails {
        var libraryName = ""
        var description = ""
    }
    var selectedIndexPath: Int?
    
    private var arrayOfLibraryName: [structLibraryDetails] = [
        structLibraryDetails(libraryName: "Description", description: ""),
        structLibraryDetails(libraryName: "Alamofire", description: DescriptionLibrary.Alamofire),
        structLibraryDetails(libraryName: "SDWebImage", description: DescriptionLibrary.SDWebImage),
        structLibraryDetails(libraryName: "Koloda", description: DescriptionLibrary.Koloda),
        structLibraryDetails(libraryName: "SkeletonView", description: DescriptionLibrary.SkeletonView),
        structLibraryDetails(libraryName: "SKPhotoBrowser", description: DescriptionLibrary.SKPhotoBrowser),
        structLibraryDetails(libraryName: "SwiftyJson", description: DescriptionLibrary.SwiftyJson),
        structLibraryDetails(libraryName: "TLPhotoPicker", description: DescriptionLibrary.TLPhotoPicker)
    ]
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: LicenseDetailsViewModel, viewController: LicenseDetailsVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    
    //MARK: - Register Tableview cell xibs
    func registerTableCell(){
        tableView.registerNib(nibNames: [LicenseDiscriptionCell.identifier, LicenseLibraryNameCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: - UITableview Delegate and Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfLibraryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LicenseDiscriptionCell.identifier) as! LicenseDiscriptionCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LicenseLibraryNameCell.identifier) as! LicenseLibraryNameCell
            let libData = arrayOfLibraryName[indexPath.row]
            cell.labelLibraryName.text = libData.libraryName
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let libData = arrayOfLibraryName[indexPath.row]
            viewController.showDefaultIOSAlert(Title: libData.libraryName, Message: libData.description)
        }
    }
}
