//
//  AddActivityDataSource.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import DropDown
import TLPhotoPicker
import Photos
import MapKit
import CoreLocation

struct activityAddressStruct {
    var address = ""
    var city = ""
    var state = ""
    var country = ""
    var latitude = ""
    var longitude = ""
    var pincode = ""
    var address_id = ""
}

struct activitySubCategoryStruct {
    var activity_category_id = ""
    var activity_sub_category_id = ""
}

class AddActivityDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: AddActivityVC
    private let tableView: UITableView
    private let viewModel: AddActivityViewModel
    //    var mapView: MKMapView
    
    var arrayOfSelectedImages = [UIImage]()
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    enum enumAddActivityTableRow: Int, CaseIterable {
        case category = 0
        case shortTitle
        case photo
        case date
        case description
        case location
    }
    
    var activityAddressValues = activityAddressStruct()
    var newPin = MKPointAnnotation()
    var isLocationChangedByUser = false
    private var mapChangedFromUserInteraction = false
    private let isPremium = IsPremium()

    
    //MARK:- Init
    init(tableView: UITableView, viewModel: AddActivityViewModel, viewController: AddActivityVC) {
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
        tableView.registerNib(nibNames: [BorderedTextFieldCell.identifier, ActivityDateCell.identifier, ActivityPhotoCell.identifier, ActivityDescriptionCell.identifier, ActivityLocationCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: - UIButton Action
    @objc func buttonAddMediaAction(_ sender: UIButton) {
        openTLPhotoPicker()
    }
    
    @objc func buttonCancelMediaAction(_ sender: UIButton) {
        self.viewModel.removeActivityMedia(at: 0)
        self.arrayOfSelectedImages.removeAll()
        self.tableView.reloadRows(at: [IndexPath(row:enumAddActivityTableRow.photo.rawValue, section:0)], with: .none)
    }
    
    @objc func buttonChangeDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: sender.date).day ?? 0
        
        //Check selected date and current date diference is greater than 30 for basic plan user
        if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
            if diffInDays > 30 {
                self.viewModel.setIsSelectedDateNotValid(value: true)
                self.viewModel.setDate(value: selectedDate)
                viewController.alertCustom(btnNo:Constants.btn_cancel, btnYes: Constants.btn_viewPlan, title: "", message: Constants_Message.activity_wrongSelectDate_validation) {
                    let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
                    subscriptionplanvc.isFromOtherScreen = true
                    self.viewController.present(subscriptionplanvc, animated: true)
                }
            } else {
                self.viewModel.setIsSelectedDateNotValid(value: false)
                self.viewModel.setDate(value: selectedDate)
            }
        } else {
            self.viewModel.setIsSelectedDateNotValid(value: false)
            self.viewModel.setDate(value: selectedDate)
        }
    }
    
    @objc func buttonSetCurrentLocation(_ sender: UIButton) {
        isLocationChangedByUser = false
        mapChangedFromUserInteraction = false
        determineCurrentLocation()
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    @objc func buttonDropDownAction(_ sender: UIButton) {
        setupDropDownUI()
        if let arrCategory = Constants.loggedInUser?.userInterestedCategory {
            var arrCategoryTitle = arrCategory.map({$0.activityCategoryTitle!})
            arrCategoryTitle = arrCategoryTitle.removeDuplicates()
            
            var arrActivityId = arrCategory.map({$0.activityId})
            arrActivityId = arrActivityId.removeDuplicates()
            
            let settingView = DropDown()
            settingView.dataSource = arrCategoryTitle
            settingView.width = sender.width
            settingView.anchorView = sender
            settingView.direction = .bottom
            settingView.bottomOffset = CGPoint(x: 0, y:(settingView.anchorView?.plainView.bounds.height)!)
            settingView.selectionAction = { [unowned self] (index: Int, item: String) in
                
                print(item)
                
                self.viewModel.removeActivityAllSubCategory()
                self.viewModel.setActivityCategoryTitle(value: item)
                
                let arrSubCategory = arrCategory.filter({$0.activityId == arrActivityId[index]})
                
                for i in 0..<arrSubCategory.count {
                    let obj = arrSubCategory[i]
                    
                    var dict = activitySubCategoryStruct()
                    dict.activity_category_id = "\(arrActivityId[index] ?? 0)"
                    dict.activity_sub_category_id = "\(obj.subActivityId ?? 0)"
                    
                    self.viewModel.setActivitySubCategory(value: dict)
                }
                
                self.tableView.reloadRows(at: [IndexPath(row:enumAddActivityTableRow.category.rawValue, section:0)], with: .none)
                
                settingView.hide()
            }
            settingView.show()
        }
    }
    
    //MARK: Dropdown Popup UI
    func setupDropDownUI() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = Constants.color_DarkGrey
        appearance.textFont = CustomFont.THEME_FONT_Medium(14)!
        appearance.cellHeight = 50
        appearance.separatorColor = Constants.color_MediumGrey
        appearance.backgroundColor = Constants.color_white
    }
    
    //MARK: - UITableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumAddActivityTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumAddActivityTableRow(rawValue: indexPath.row)! {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = Constants.label_activityCategory
            cell.textfiled.placeholder = Constants_Message.activity_category_placeholder
            cell.textfiled.text = self.viewModel.getActivityCategoryTitle()
            cell.buttonDropDown.isHidden = false
            cell.buttonDropDown.addTarget(self, action: #selector(buttonDropDownAction(_:)), for: .touchUpInside)
            cell.buttonDropDown.tag = enumAddActivityTableRow.category.rawValue
            cell.textfiled.tag = enumAddActivityTableRow.category.rawValue
            cell.labelMaxLimit.isHidden = true
            return cell
            
        case .shortTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = Constants.label_shortTitle
            cell.textfiled.placeholder = Constants.placeholder_shortTitle
            cell.textfiled.tag = enumAddActivityTableRow.shortTitle.rawValue
            cell.buttonDropDown.isHidden = true
            cell.textfiled.delegate = self
            cell.labelMaxLimit.isHidden = false
            cell.textfiled.text = viewModel.getTitle()
            return cell
            
            
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityPhotoCell.identifier) as! ActivityPhotoCell
            cell.selectionStyle = .none
            cell.labelPhotoTitle.text = Constants.label_photo
            
            if viewModel.getActivityAllMedia().count > 0 {
                cell.imageviewPhoto.image = viewModel.getActivityAllMedia()[0]
                cell.labelPhotoDescription.isHidden = true
                cell.imageviewPhoto.contentMode = .scaleAspectFill
                cell.buttonAdd.isHidden = true
                cell.buttonCancel.isHidden = false
                cell.buttonCancel.addTarget(self, action: #selector(buttonCancelMediaAction(_:)), for: .touchUpInside)
                
            } else {
                cell.imageviewPhoto.image = nil
                cell.labelPhotoDescription.isHidden = false
                cell.buttonAdd.isHidden = false
                cell.buttonCancel.isHidden = true
                cell.buttonAdd.addTarget(self, action: #selector(buttonAddMediaAction(_:)), for: .touchUpInside)
            }
            
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDateCell.identifier) as! ActivityDateCell
            cell.selectionStyle = .none
            cell.labelDateTitle.text = Constants.label_date
            
            if !viewModel.getActivityDate().isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  UTC_FORMAT
                
                if let date = dateFormatter.date(from: viewModel.getActivityDate()) {
                    cell.datepicker.date = date
                } else {
                    dateFormatter.dateFormat =  "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: viewModel.getActivityDate()) {
                        cell.datepicker.date = date
                    }
                }
            }
            cell.datepicker.addTarget(self, action: #selector(buttonChangeDate(_:)), for: .valueChanged)
            
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDescriptionCell.identifier) as! ActivityDescriptionCell
            
            cell.selectionStyle = .none
            cell.labelTextViewTitle.text = Constants.label_description
            cell.textview.tag = enumAddActivityTableRow.description.rawValue
            cell.textview.delegate = self
            
            if viewModel.getDescription().isEmpty {
                cell.textview.text = Constants.placeholder_activityDescription
                cell.textview.textColor = Constants.color_MediumGrey
            } else {
                cell.textview.text = viewModel.getDescription()
                cell.textview.textColor = Constants.color_DarkGrey
            }
            
            return cell
            
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLocationCell.identifier) as! ActivityLocationCell
            cell.selectionStyle = .none
            cell.labelLocationTitle.text = Constants.label_location
            
            cell.mapview.delegate = self
            cell.mapview.mapType = .standard
            cell.mapview.isZoomEnabled = true
            cell.mapview.isScrollEnabled = true
            
            cell.buttonCurrentLocation.isUserInteractionEnabled = true
            cell.buttonCurrentLocation.addTarget(self, action: #selector(buttonSetCurrentLocation(_:)), for: .touchUpInside)
            
            let arrAddress = viewModel.getAllActivityAddress()
            
            if arrAddress.count > 0 {
                let obj = arrAddress[0]
                
                let lat = Double(obj.latitude)
                let long = Double(obj.longitude)
                
                let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: locValue, span: span)
                cell.mapview.setRegion(region, animated: true)
                
                newPin.coordinate = locValue
                newPin.title = obj.address
                cell.mapview.addAnnotation(newPin)
            } else {
                determineCurrentLocation()
            }
            
            //            if let coor = cell.mapview.userLocation.location?.coordinate {
            //                cell.mapview.setCenter(coor, animated: true)
            //            }
            
            let gestureRecognizer = UITapGestureRecognizer(
                target: self, action:#selector(handleTap))
            cell.mapview.addGestureRecognizer(gestureRecognizer)
            
            return cell
        }
    }
    
    
    //MARK: - TLPhotosPicker Library
    func checkPhotoLibraryPermission(completion: (Bool) -> ()) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            completion(true)
            break
        case .denied, .restricted :
            //handle denied status
            completion(false)
            break
        case .notDetermined:
            // ask for permissions
            completion(true)
            break
        case .limited:
            completion(true)
            break
        @unknown default:
            break
        }
    }
    
    func openTLPhotoPicker() {
        checkPhotoLibraryPermission(completion: {(value) -> Void in
            if value {
                let photoViewController = TLPhotosPickerViewController()
                photoViewController.delegate = self
                var configure = TLPhotosPickerConfigure()
                if(arrayOfSelectedImages.count == 0) {
                    configure.maxSelectedAssets = MaxActivitySelect
                } else {
                    configure.maxSelectedAssets = MaxPictureSelect - arrayOfSelectedImages.count
                }
                configure.allowedVideo = false
                configure.allowedLivePhotos = false
                configure.allowedPhotograph = true
                configure.allowedVideoRecording = false
                photoViewController.configure = configure
                
                viewController.present(photoViewController, animated: true, completion: nil)
            } else {
                
                viewController.alertCustom(btnNo: Constants_Message.alert_title_setting, btnYes: Constants.btn_cancel, title: "", message: Constants_Message.alert_media_setting_message) {
                    
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        })
    }
}

//MARK: Extension TLPhotoPicker
extension AddActivityDataSource: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        if withTLPHAssets.count > 0 {
            self.viewModel.removeActivityAllMedia()
            
            for i in withTLPHAssets{
                if i.phAsset?.mediaType == .image {
                    let selectedImage = UIImage.upOrientationImage(i.fullResolutionImage!)
                    self.arrayOfSelectedImages.append(selectedImage() ?? UIImage())
                    self.viewModel.setActivityMedia(value: selectedImage() ?? UIImage())
                }
            }
        }
        
        self.tableView.reloadData()
        return true
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }
}

//MARK: - TextField Delegate
extension AddActivityDataSource: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch enumAddActivityTableRow(rawValue: textField.tag) {
        case .shortTitle:
            let maxLength = 30
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        default:
            break
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch enumAddActivityTableRow(rawValue: textField.tag) {
        case .shortTitle:
            viewModel.setTitle(value: (textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
            break
        default:
            break
        }
    }
}

//MARK: --------------------------------------------------
//MARK: Extension Textview Delegate
extension AddActivityDataSource : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.color_MediumGrey {
            textView.text = nil
            textView.textColor = Constants.color_DarkGrey
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.setDescription(value: (textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholder_activityDescription
            textView.textColor = Constants.color_MediumGrey
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 200
    }
}

extension AddActivityDataSource: CLLocationManagerDelegate,MKMapViewDelegate {
    
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
        if let cell = tableView.cellForRow(at: IndexPath(row:enumAddActivityTableRow.location.rawValue, section:0)) as? ActivityLocationCell {
            
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
        if let cell = tableView.cellForRow(at: IndexPath(row:enumAddActivityTableRow.location.rawValue, section:0)) as? ActivityLocationCell {
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
            
            if let cell = tableView.cellForRow(at: IndexPath(row:enumAddActivityTableRow.location.rawValue, section:0)) as? ActivityLocationCell {
               
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
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
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
                    
                    self.activityAddressValues.latitude = pdblLatitude
                    self.activityAddressValues.longitude = pdblLongitude
                    
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    print(pm.administrativeArea)
                    
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    
                    if pm.administrativeArea != nil {
                        self.activityAddressValues.state = pm.administrativeArea!
                    }
                    
                    if pm.locality != nil {
                        self.activityAddressValues.city = pm.locality!
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        self.activityAddressValues.country = pm.country!
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        self.activityAddressValues.pincode = pm.postalCode!
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                    self.viewModel.removeActivityAddress()
                    self.activityAddressValues.address = addressString
                    
                    if self.viewController.isEditActivity {
                        if let arrAddress = self.viewController.objActivityDetails?.activityDetails, arrAddress.count > 0 {
                            let obj = arrAddress[0]
                            self.activityAddressValues.address_id = "\(obj.id ?? 0)"
                        }
                    }
                    
                    self.viewModel.setActivityAddress(value: self.activityAddressValues)
                    
                    let arrdict = self.viewModel.getAllActivityAddress()
                    
                    if arrdict.count > 0 {
                        let dictValues = arrdict[0]
                        self.newPin.title = dictValues.address
                    }
                }
            }
        })
    }
    
    func openLocationSettings() {
        viewController.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_settings, title: "", message: Constants.label_locationPermissionAlertMsg) {
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
}
