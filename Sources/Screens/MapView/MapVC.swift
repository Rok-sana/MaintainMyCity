//
//  MapVC.swift
//  MaintainMyCity
//
//  Created by swstation on 9/14/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    var router: FlowRouter!
    var viewModel: MapViewModelType!
    
    @IBOutlet weak var mapView: MKMapView!
    
    func configure(viewModel: MapViewModelType, router: FlowRouter) {
        self.router = router
        self.viewModel = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let camera = MKMapCamera(lookingAtCenter: viewModel.coordinate, fromDistance: 100, pitch: 0, heading: 0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = viewModel.coordinate
        
        mapView.addAnnotation(annotation)
        
        //        mapView.setCenter(viewModel.coordinate, animated: true)
        mapView.setCamera(camera, animated: true)
    }
    
}
