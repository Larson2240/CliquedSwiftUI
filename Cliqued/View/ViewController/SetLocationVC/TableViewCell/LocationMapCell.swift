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
            viewMap.layer.cornerRadius = 10.0
            viewMap.clipsToBounds = true
        }
    }
    @IBOutlet weak var mapview: MKMapView!
    
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
        setupMapView()
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
extension LocationMapCell: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapview.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapview.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        mapview.addAnnotation(annotation)
    }
    
}
