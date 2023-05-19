//
//  PickActivityDataSource.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class PickActivityDataSource: NSObject {
    
    private let viewController: PickActivityVC
    private let collectionView: UICollectionView
    private var selectedItemIndex: Int?
    
    //MARK:- Init
    init(collectionView: UICollectionView, viewController: PickActivityVC) {
        self.viewController = viewController
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
        collectionView.registerNib(nibNames: [ActivityCVCell.identifier])
        collectionView.reloadData()
    }
    
}
//MARK: Extension UICollectionview
extension PickActivityDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2
        return CGSize(width: cellWidth, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCVCell", for: indexPath) as! ActivityCVCell
        cell.imageviewActivity.image = UIImage(named: "travel")
        cell.labelActivityName.text = "Travel & Outdoor"
        
        if selectedItemIndex == indexPath.item {
            cell.imageviewAlpha.isHidden = false
            cell.imageviewSelectedIcon.isHidden = false
        } else {
            cell.imageviewAlpha.isHidden = true
            cell.imageviewSelectedIcon.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItemIndex = indexPath.item
        collectionView.reloadData()
    }
}
