//
//  MapVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import UIKit
import GoogleMaps
import CoreLocation

class DefineLocationOnMapVC: UIViewController {
    
    let marker: GMSMarker = GMSMarker()
    var where_from: Bool = false
    let locationManager = CLLocationManager()
    let didFindMyLocation = false
    var coordinate: CLLocationCoordinate2D?
    var locationDelegate: AddLocationProtocol?
    
    var mainView: DefineLocationOnMapView {
        return view as! DefineLocationOnMapView
    }
    
    override func loadView() {
        super.loadView()
        view = DefineLocationOnMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
        mainView.mapView.isMyLocationEnabled = true
        mainView.mapView.settings.myLocationButton = true
        mainView.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        setupCallbacks()
        
    }
    
    func setupCallbacks(){
        mainView.addLocationClickCallback = { [weak self] in
            if self!.coordinate == nil {
                PopUpLancher.showWarningMessage(text: "tap_on_map_to_add_location".localized())
            }else{
                self!.locationDelegate?.giveLocation(coordinate: self!.coordinate!, where_from: self!.where_from)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
       
        }
        
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
  
}

extension DefineLocationOnMapVC: CLLocationManagerDelegate {
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)! ,longitude: (location?.coordinate.longitude)! , zoom: 15.0)
//        let camera = GMSCameraPosition.cameraWithLatitude((location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.mainView.mapView.animate(to: camera)

        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }
}

extension DefineLocationOnMapVC: GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        marker.title = "location_to_add".localized()
        marker.snippet = ""
        
        marker.appearAnimation = .pop
        marker.position = coordinate
        self.coordinate = coordinate
        DispatchQueue.main.async {
            self.marker.map = self.mainView.mapView
        }
    }

}
