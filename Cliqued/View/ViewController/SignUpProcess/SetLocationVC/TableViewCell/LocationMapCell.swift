//
//  LocationMapCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import MapKit
import CoreLocation

class LocationMapCell: UITableViewCell {
    
    @IBOutlet weak var viewMap: UIView!{
        didSet {
            viewMap.layer.cornerRadius = 16.0
            viewMap.clipsToBounds = true
        }
    }
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var buttonCurrentLocation: UIButton!{
        didSet {
            buttonCurrentLocation.setTitle(Constants.btn_goToCurrentLocation, for: .normal)
            buttonCurrentLocation.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonCurrentLocation.titleLabel?.font = CustomFont.THEME_FONT_Medium(17)
            buttonCurrentLocation.layer.cornerRadius = 10.0
            buttonCurrentLocation.backgroundColor = Constants.color_white
        }
    }
    
//    //MARK: Variable
//    lazy var locationManager: CLLocationManager = {
//        var manager = CLLocationManager()
//        manager.distanceFilter = 10
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        return manager
//    }()

    override func awakeFromNib() {
        super.awakeFromNib()
//        setupMapView()
    }
    
    func setupMapView() {
        mapview.showsUserLocation = false
        
        if let coor = mapview.userLocation.location?.coordinate{
            mapview.setCenter(coor, animated: true)
        }
    }
}
