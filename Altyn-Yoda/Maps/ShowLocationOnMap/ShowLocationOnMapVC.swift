//
//  ShowLocationOnMapVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 18.04.2023.
//

import UIKit
import GoogleMaps

class ShowLocationOnMapVC: UIViewController {
    
    var where_from: Bool = false
    var coordinates: String = ""
    
    var mainView: ShowLocationOnMapView {
        return view as! ShowLocationOnMapView
    }
    
    override func loadView() {
        super.loadView()
        view = ShowLocationOnMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
        
        mainView.mapView.isMyLocationEnabled = true
        mainView.mapView.settings.myLocationButton = true
        mainView.mapView.delegate = self
        
        showSelectedLocation()
    }
    
    func showSelectedLocation(){
        let coordinates = self.coordinates.components(separatedBy: "x")
        guard let lat = Double(coordinates.first ?? "0.0"),
              let lng = Double(coordinates.last ?? "0.0") else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15.0)
        mainView.mapView.animate(to: camera)
        showMarker(position: camera.target)
    }
    
    func setupCallbacks(){
        
        mainView.header.backBtnClickCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension ShowLocationOnMapVC: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let coordinates = self.coordinates.components(separatedBy: "x")
        guard let lat = Double(coordinates.first ?? "0.0"),
              let lng = Double(coordinates.last ?? "0.0") else { return false }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15.0)
        mainView.mapView.animate(to: camera)
        showMarker(position: camera.target)
        return true
    }
    
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        if self.where_from {
            marker.title = "location_from"
        }else{
            marker.title = "location_to"
        }
        marker.map = mainView.mapView
    }
}
