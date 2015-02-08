//
//  MapViewController.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa
import MapKit

class MapViewController: NSViewController, MKMapViewDelegate, ConnectionCallbackDelegate {
    @IBOutlet var mapView: MKMapView?
    
    var uniqueLocationDict = [String: Int]()
    let operationQueue = NSOperationQueue()
    
    func handleMapConnections(lsofLocations: [(LsofLocation)]) {
        for lsofLocation in lsofLocations {
            let lsof = lsofLocation.lsof
            let location = lsofLocation.location
            
            let keyStr = "\(lsofLocation.location.latitude)\(lsofLocation.location.longitude)"
             (lsofLocation.location.city != "" ? location.city : location.country)
            if uniqueLocationDict[keyStr] == nil {
                uniqueLocationDict[keyStr] = 1
                let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                var annotation = MKPointAnnotation()
                annotation.coordinate = coord
                annotation.title = lsof.command
                annotation.subtitle = location.locationString()
                self.mapView!.addAnnotation(annotation)
            }
        }
        self.queueOperation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.queueOperation()
    }
    
    func queueOperation() {
        let co = ConnectionOperation()
        co.queuePriority = NSOperationQueuePriority.VeryLow
        co.qualityOfService = NSQualityOfService.Background
        co.delegate = self
        operationQueue.addOperations([co], waitUntilFinished: false)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}