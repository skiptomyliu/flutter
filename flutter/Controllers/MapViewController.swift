//
//  MapViewController.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

//import Foundation
import Cocoa
import MapKit

class MapViewController: NSViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}