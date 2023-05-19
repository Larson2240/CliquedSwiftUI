//
//  SetLocationDataSource.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import MapKit
import CoreLocation
import StepSlider

class SetLocationDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SetLocationVC
    private let tableView: UITableView
    private let viewModel: SignUpProcessViewModel
    
    enum enumSetLocationTableRow: Int, CaseIterable {
        case mapview = 0
        case pickDistance
    }
    var locationManager:CLLocationManager!
    var addressDic = structAddressParam()
    
    var newPin = MKPointAnnotation()
    var isLocationChangedByUser = false
    private var mapChangedFromUserInteraction = false
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SignUpProcessViewModel, viewController: SetLocationVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    
    func registerTableCell(){
        tableView.registerNib(nibNames: [LocationMapCell.identifier, LocationDistanceCell.identifier])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumSetLocationTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSetLocationTableRow(rawValue: indexPath.row)! {
        case .mapview:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationMapCell.identifier) as! LocationMapCell
            cell.selectionStyle = .none
            
            cell.mapview.delegate = self
            cell.mapview.mapType = .standard
            cell.mapview.isZoomEnabled = true
            cell.mapview.isScrollEnabled = true
            
            if let obj = viewController.objAddress {
                let lat = Double(obj.latitude ?? "0.0")
                let long = Double(obj.longitude ?? "0.0")
                
                let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: locValue, span: span)
                cell.mapview.setRegion(region, animated: true)
                let fullAddress = "\(obj.address ?? "") \(obj.city ?? "") \(obj.state ?? "") \(obj.country ?? "") \(obj.pincode ?? "")"
                
                newPin.coordinate = locValue
                newPin.title = fullAddress
                cell.mapview.addAnnotation(newPin)
            } else {
                determineCurrentLocation()
            }
            
            let gestureRecognizer = UITapGestureRecognizer(
                target: self, action:#selector(handleTap))
            cell.mapview.addGestureRecognizer(gestureRecognizer)
            
            cell.buttonCurrentLocation.tag = indexPath.row
            cell.buttonCurrentLocation.addTarget(self, action: #selector(btnCurrentLocationTap(_:)), for: .touchUpInside)
            
            return cell
        case .pickDistance:
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationDistanceCell.identifier) as! LocationDistanceCell
            cell.selectionStyle = .none
            if !viewController.isFromEditProfile {
                self.setupDefaultDistantce()
            } else {
                if cell.sliderDistance.labels.count > 0 {
                    for i in 0...cell.sliderDistance.labels.count - 1 {
                        if "\(viewController.distancePreference)km" == cell.sliderDistance.labels[i] as? String {
                            cell.sliderDistance.index = UInt(i)
                        }
                    }
                }
            }
            cell.sliderDistance.addTarget(self, action: #selector(handleSliderValueChange(_:)), for: .valueChanged)
            return cell
        }
    }
    
    //MARK: Button current location tap
    @objc func btnCurrentLocationTap(_ sender: UIButton) {
        isLocationChangedByUser = false
        mapChangedFromUserInteraction = false
        determineCurrentLocation()
    }
    //MARK: Handle distance slider
    @objc func handleSliderValueChange(_ sender: StepSlider) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.distance}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                var dict = structDistanceParam()
                dict.distancePreferenceId = arrayOfTypeOption[Int(sender.index)].preferenceId?.description ?? ""
                dict.distancePreferenceOptionId = arrayOfTypeOption[Int(sender.index)].id?.description ?? ""
                viewModel.setDistance(value: dict)
            }
        }
    }
    //MARK: Setup default distance
    func setupDefaultDistantce() {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.distance}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                var dict = structDistanceParam()
                dict.distancePreferenceId = arrayOfTypeOption[0].preferenceId?.description ?? ""
                dict.distancePreferenceOptionId = arrayOfTypeOption[0].id?.description ?? ""
                viewModel.setDistance(value: dict)
            }
        }
    }
}
//MARK: Extension CLLocationManager
extension SetLocationDataSource: CLLocationManagerDelegate, MKMapViewDelegate {
    
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
        if let cell = tableView.cellForRow(at: IndexPath(row:enumSetLocationTableRow.mapview.rawValue, section:0)) as? LocationMapCell {
            
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
                    if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                        return true
                    }
                }
            }
        }
        return false
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        print("mapChangedFromUserInteraction regionWillChangeAnimated => \(mapChangedFromUserInteraction)")

    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            print("ZOOM finished")
            print("mapChangedFromUserInteraction regionDidChangeAnimated => \(mapChangedFromUserInteraction)")
        }
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
                                    {(placemarks, error) in
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func openLocationSettings() {
        viewController.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_settings, title: "", message: Constants.label_locationPermissionAlertMsg) {
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}
