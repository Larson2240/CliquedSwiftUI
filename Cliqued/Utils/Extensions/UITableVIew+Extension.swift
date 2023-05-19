//
//  UITableVIew+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 25/05/20.
//  Copyright © 2020 C100-107. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(nibNames: [String]) {
        for nibName in nibNames {
            self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        }
    }
    
    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

extension UITableViewCell {
    
    static var defaultCell: UITableViewCell {
        let cell = UITableViewCell()
        cell.clearCell()
        return cell
    }
    
    static var identifier: String {
        return (self.description().split(separator: ".").last?.description) ?? ""
    }
    
    func clearCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageView?.image = nil
        textLabel?.text = nil
        
        selectionStyle = .none
    }
}
