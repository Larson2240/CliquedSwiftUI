//
//  LocationViewModel.swift
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

final class LocationViewModel: NSObject, ObservableObject {
    private var locationManager: CLLocationManager!
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var annotations: [Pin] = []
    var addressDic = AddressParam()
    
    var isFromEditProfile: Bool?
    var addressId = ""
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async { [weak self] in
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
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) {
        let lat = mapRegion.center.latitude
        let lon = mapRegion.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width / 2, y: mapSize.height / 2)
        
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * mapRegion.span.longitudeDelta / 2
        
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * mapRegion.span.latitudeDelta / 2
        
        let coordinate = CLLocationCoordinate2D(latitude: lat - ySpan, longitude: lon + xSpan)
        
        getAddressFromLatLon(pdblLatitude: "\(coordinate.latitude)", withLongitude: "\(coordinate.longitude)") { [weak self] address in
            let pin = Pin(id: UUID(),
                          coordinate: coordinate,
                          title: address)
            
            DispatchQueue.main.async {
                    self?.mapRegion.center = coordinate
                    self?.mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    self?.annotations = [pin]
            }
        }
    }
    
    func setupUserLocation(with userAddress: UserAddress?) {
        if let obj = userAddress {
            let lat = Double(obj.latitude ?? "0.0")
            let long = Double(obj.longitude ?? "0.0")
            
            let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: locValue, span: span)
            let fullAddress = "\(obj.address ?? "") \(obj.city ?? "") \(obj.state ?? "") \(obj.country ?? "") \(obj.pincode ?? "")"
            let newAnnotation = Pin(id: UUID(), coordinate: locValue, title: fullAddress)
            
            DispatchQueue.main.async { [weak self] in
                self?.mapRegion = region
                self?.annotations = [newAnnotation]
            }
        } else {
            determineCurrentLocation()
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, completion: @escaping (String) -> Void) {
        var center = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let long: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = long
        var addressString : String = ""
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler: { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion("")
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
                    
                    if self.isFromEditProfile ?? false {
                        self.addressDic.address_id = self.addressId
                    } else {
                        self.addressDic.address_id = "0"
                    }
                    
                    let fullAddress = "\(pm.name ?? "") \(pm.locality ?? "") \(pm.administrativeArea ?? "") \(pm.country ?? "") \(pm.postalCode ?? "")"
                    
                    completion(fullAddress)
                } else {
                    completion("")
                }
            }
        })
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Permission authorized")
        } else if status == .denied {
            print("Permission denied")
            openLocationSettings()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let locValue:CLLocationCoordinate2D = location.coordinate
        
        annotations = []
        getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)") { _ in }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        withAnimation {
            mapRegion = region
            let newAnnotation = Pin(id: UUID(), coordinate: locValue, title: "")
            annotations = [newAnnotation]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
