//
//  GuideManagerVC.swift
//  Cliqued
//
//  Created by C211 on 01/03/23.
//

import UIKit
import SDWebImage

class GuideManagerVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var collectionview: UICollectionView!
    
    //MARK: Variable
    var dataSource: GuideManagerDataSource?
    var isFromActivitiesScreen: Bool = false
    var isFromUserSwipeScreen: Bool = false
    var isFromActivitySwipeScreen: Bool = false
    var count: Int = 0
    var deviceScale: CGFloat = 0.0
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
//MARK: Extension UDF
extension GuideManagerVC {
    
    func viewDidLoadMethod() {
        self.dataSource = GuideManagerDataSource(viewController: self, collectionView: collectionview)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
        deviceScale = UIScreen.main.scale      
    }
}
