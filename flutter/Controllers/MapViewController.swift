//
//  MapViewController.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa
import MapKit

class MapViewController: NSViewController, MKMapViewDelegate, ConnectionCallbackDelegate, AppViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var summaryView: SummaryView!
    @IBOutlet var appView: AppView!
    @IBOutlet var detailsView: DetailsView!
    
    var uniqueLocationDict = [String: Int]()
    let operationQueue = NSOperationQueue()
    var savedLsofLocations = [LsofLocation]()
    
    // AppView delegate callback method
    func appViewRowSelected(lsofLocations: [LsofLocation]) {
        /* load the details of the app and show only locations pertaining to selected app */
        self.mapView.removeAnnotations(self.mapView.annotations)
        if lsofLocations.count > 0 {
            self.addAnnotations(lsofLocations)
        } else {
            self.addAnnotations(self.savedLsofLocations)
        }
    }
    
    // ConnectionOperations delegate callback method
    func connectionOperationHandleMapConnections(lsofLocations: [LsofLocation]) {
        self.savedLsofLocations = lsofLocations
        self.addAnnotations(lsofLocations)
        self.queueOperation()
    }
    
    func addAnnotations(lsofLocations: [LsofLocation]) {
        for lsofLocation in lsofLocations {
            self.addAnnotation(lsofLocation)
        }
    }
    
    func addAnnotation(lsofLocation: LsofLocation) {
        let lsof = lsofLocation.lsof
        let location = lsofLocation.location
        let metadata = lsofLocation.metadata
        let keyStr = "\(location.latitude)\(location.longitude)"
        
//        if uniqueLocationDict[keyStr] == nil {
            uniqueLocationDict[keyStr] = 1
            let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            var annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = metadata.applicationName
            annotation.subtitle = location.locationString()
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(annotation)
            })//end main queue
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.appView.delegates.append(self)
        self.appView.delegates.append(self.detailsView)
        self.queueOperation()
    }
    
    // Move queue operation somewhere else?
    func queueOperation() {
        let co = ConnectionOperation()
        co.queuePriority = NSOperationQueuePriority.VeryLow
        co.qualityOfService = NSQualityOfService.Background
        co.delegates.append(self)
        co.delegates.append(self.summaryView)
        co.delegates.append(self.appView)
        operationQueue.addOperations([co], waitUntilFinished: false)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}