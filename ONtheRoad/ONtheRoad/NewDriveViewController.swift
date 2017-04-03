//
//  NewDriveViewController.swift
//  ONtheRoad
//
//  Created by Michael Dickenson on 2017-04-02.
//  Copyright © 2017 Santiago Félix Cárdenas. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import MapKit

class NewDriveViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager!
    var mapOverlay: MKTileOverlay!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self;
        
        mapView.showsUserLocation = true
    }
    
    //Display the map
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isZoomEnabled = true;
        mapView.isScrollEnabled = true;
        mapView.isUserInteractionEnabled = false;
        mapView.isHidden = false
        let regionRadius: CLLocationDistance = 100
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,regionRadius * 1.1, regionRadius * 1.1)
        mapView.setRegion(coordinateRegion, animated: true)

    }
    //*******************
    
    //Keeps the map centered
    func centerMapOnLocation(location: CLLocation, distance: CLLocationDistance) {
//This needs to get the user location stuff from TripData
        let regionRadius = distance
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 1.1, regionRadius * 1.1)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //*******************
    
    //Rendering the live feed line on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    //*******************
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
