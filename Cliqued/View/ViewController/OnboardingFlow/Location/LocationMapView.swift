//
//  LocationMapView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.05.2023.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var userAddresses: [Pin] = []
    
    var objAddress: UserAddress?
    
    var body: some View {
        let width = screenSize.width - 32
        
        ZStack {
            mapView
            
            currentLocationButton
        }
        onAppear { setupAddresses() }
        .frame(width: width, height: width - 60)
    }
    
    private var mapView: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: userAddresses) { item in
            MapPin(coordinate: item.coordinate)
        }
            .cornerRadius(16)
    }
    
    private var currentLocationButton: some View {
        VStack {
            Spacer()
            
            Button(action: {  }) {
                ZStack {
                    Color.white
                    
                    HStack {
                        Image("ic_current_location")
                        
                        Text(Constants.btn_goToCurrentLocation)
                            .foregroundColor(.colorDarkGrey)
                            .font(.themeMedium(17))
                    }
                }
                .cornerRadius(10)
                .frame(height: 60)
            }
        }
        .padding(16)
    }
    
    private func setupAddresses() {
        guard let obj = objAddress else { return }
        
        let lat = Double(obj.latitude ?? "0.0")
        let long = Double(obj.longitude ?? "0.0")
        
        let locValue: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        mapRegion = region
        let fullAddress = "\(obj.address ?? "") \(obj.city ?? "") \(obj.state ?? "") \(obj.country ?? "") \(obj.pincode ?? "")"
        
        let newPin = Pin(id: UUID(), coordinate: locValue, title: fullAddress)
        
        userAddresses = [newPin]
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
