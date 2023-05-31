//
//  LocationManager.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 31.05.2023.
//

import SwiftUI
import MapKit

struct Pin: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let title: String
}

final class LocationManager: NSObject, ObservableObject {
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        determineCurrentLocation()
    }
    
    private func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.main.async { [weak self] in
            guard CLLocationManager.locationServicesEnabled() else { return }
            
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    private func openLocationSettings() {
        UIApplication.shared.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_settings, title: "", message: Constants.label_locationPermissionAlertMsg) {
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let long: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = long
        var addressString : String = ""
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    self.addressDic.latitude = pdblLatitude
                    self.addressDic.longitude = pdblLongitude
                    
                    if pm.name != nil {
                        addressString = addressString + pm.name!
                    }
                    
                    if pm.administrativeArea != nil {
                        self.addressDic.state = pm.administrativeArea!
                    }
                    if pm.locality != nil {
                        self.addressDic.city = pm.locality!
                    }
                    if pm.country != nil {
                        self.addressDic.country = pm.country!
                    }
                    if pm.postalCode != nil {
                        self.addressDic.pincode = pm.postalCode!
                    }
                    print(addressString)
                    self.addressDic.address = addressString
                    
                    if self.viewController.isFromEditProfile {
                        self.addressDic.address_id = self.viewController.addressId
                    } else {
                        self.addressDic.address_id = "0"
                    }
                    
                    let fullAddress = "\(pm.name ?? "") \(pm.locality ?? "") \(pm.administrativeArea ?? "") \(pm.country ?? "") \(pm.postalCode ?? "")"
                    
                    
                    if let cell = self.tableView.cellForRow(at: IndexPath(row:enumSetLocationTableRow.mapview.rawValue, section:0)) as? LocationMapCell {
                        self.newPin.title = fullAddress
                        cell.mapview.addAnnotation(self.newPin)
                    }
                }
            }
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Permission authorized")
        } else if status == .denied {
            print("Permission denied")
            openLocationSettings()
        }
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        isLocationChangedByUser = true
        if let cell = tableView.cellForRow(at: IndexPath(row: enumSetLocationTableRow.mapview.rawValue, section:0)) as? LocationMapCell {
            
            cell.mapview.removeAnnotation(newPin)
            
            let location = gestureRecognizer.location(in: cell.mapview)
            let coordinate = cell.mapview.convert(location, toCoordinateFrom: cell.mapview)
            
            cell.mapview.mapType = MKMapType.standard
            getAddressFromLatLon(pdblLatitude: "\(coordinate.latitude)", withLongitude: "\(coordinate.longitude)")
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            cell.mapview.setRegion(region, animated: true)
            newPin.coordinate = coordinate
            cell.mapview.addAnnotation(newPin)
        }
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        if let cell = tableView.cellForRow(at: IndexPath(row:enumSetLocationTableRow.mapview.rawValue, section:0)) as? LocationMapCell {
            let view = cell.mapview.subviews[0]
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    if (recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isLocationChangedByUser && !mapChangedFromUserInteraction {
            let location = locations.last! as CLLocation
            let locValue:CLLocationCoordinate2D = location.coordinate
            
            if let cell = tableView.cellForRow(at: IndexPath(row:enumSetLocationTableRow.mapview.rawValue, section:0)) as? LocationMapCell {
                
                cell.mapview.removeAnnotation(newPin)
                cell.mapview.mapType = MKMapType.standard
                getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
                
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: locValue, span: span)
                cell.mapview.setRegion(region, animated: true)
                newPin.coordinate = locValue
                cell.mapview.addAnnotation(newPin)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
