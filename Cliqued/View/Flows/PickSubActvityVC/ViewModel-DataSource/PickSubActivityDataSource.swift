//
//  PickSubActivityDataSource.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class PickSubActivityDataSource: NSObject {
    
    private let viewController: PickSubActvityVC
    private let collectionView: UICollectionView
    private var selectedItemIndex: Int?
    
    private var arrayOfSection = ["Travel & Outdoor", "Sports & Fitness", "Food & Drinks", "Gaming"]
    private var arrayOfTravel = ["Mushroom Picking", "Skiling", "Hiking", "Travel Relax", "Travel Advanture"]
    private var arrayOfSports = ["Yoga", "Running", "Dancing", "Sport Events", "Tennis", "Walking"]
    private var arrayOfFood = ["Cooking", "Wine testing", "Find dining", "Casual dining", "Drinks"]
    private var arrayOfGames = ["Board games", "Card games", "Computer games", "Bowling", "Chess"]
    
    //MARK:- Init
    init(collectionView: UICollectionView, viewController: PickSubActvityVC) {
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
        collectionView.registerNib(nibNames: [SubActivityCell.identifier])
        collectionView.register(UINib(nibName: "SubActivitySectionCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SubActivitySectionCell")
        collectionView.reloadData()
    }
    
}
//MARK: Extension UICollectionview
extension PickSubActivityDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2
        return CGSize(width: cellWidth, height: 55)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayOfSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubActivitySectionCell", for: indexPath) as! SubActivitySectionCell
            headerView.backgroundColor = .clear
            headerView.labelSectionTitle.text = arrayOfSection[indexPath.section]
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubActivityCell", for: indexPath) as! SubActivityCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItemIndex = indexPath.item
        collectionView.reloadData()
    }
}

