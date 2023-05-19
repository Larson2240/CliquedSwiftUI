//
//  ActivityLocationCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import MapKit
import CoreLocation

class ActivityLocationCell: UITableViewCell {

    @IBOutlet weak var labelLocationTitle: UILabel!{
        didSet {
            labelLocationTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelLocationTitle.textColor = Constants.color_themeColor
        }
    }
    
    
    @IBOutlet weak var viewMap: UIView!{
        didSet {
            viewMap.layer.cornerRadius = 20.0
            viewMap.clipsToBounds = true
        }
    }
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var buttonCurrentLocation: UIButton!{
        didSet {
            buttonCurrentLocation.setTitle(Constants.btn_goToCurrentLocation, for: .normal)
            buttonCurrentLocation.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonCurrentLocation.titleLabel?.font = CustomFont.THEME_FONT_Medium(17)
            buttonCurrentLocation.layer.cornerRadius = 16.0
            buttonCurrentLocation.backgroundColor = Constants.color_white
        }
    }
    
    //MARK: Variable
    var lattitude: Double = 0.0
    var longitude: Double = 0.0
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupMapView() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapview.delegate = self
        mapview.mapType = .standard
        mapview.isZoomEnabled = true
        mapview.isScrollEnabled = true
        mapview.showsUserLocation = true
        
        if let coor = mapview.userLocation.location?.coordinate{
            mapview.setCenter(coor, animated: true)
        }
    }
    
}
extension ActivityLocationCell: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapview.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapview.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = ""
        annotation.subtitle = ""
        mapview.addAnnotation(annotation)
    }
    
}
