//
//  SetLocationVC.swift
//  MaintainMyCity
//
//  Created by admin on 11/26/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SetLocationVC: UIViewController {
    private var router: FlowRouter!
    
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var localAddressLabel: UILabel!
    
    private var viewModel: SetLocationViewModelType!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    func configure(viewModel: SetLocationViewModelType, router: FlowRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        checkLocationServices()
    }
    
    @objc  func back() {
        viewModel.getLocation(address: localAddressLabel.text)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func startTackingUserLocation() {
        mapKitView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapKitView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension SetLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension SetLocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
               self.handleError(error)
                return
            }
            
            guard let placemark = placemarks?.first else {return}
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.localAddressLabel.text = "\(streetName)\(streetNumber) "
            }
        }
    }
}
