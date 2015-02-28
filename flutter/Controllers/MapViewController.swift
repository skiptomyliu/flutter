//
//  MapViewController.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa
import MapKit

class MapViewController: NSViewController, MKMapViewDelegate, ConnectionCallbackDelegate, AppViewDelegate, DetailsViewDelegate {
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
    
    func zoomIn(location: Location) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coord = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region = MKCoordinateRegion(center: coord, span: span)
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.regionThatFits(region)
    }
    
    // ConnectionOperations delegate callback method
    func connectionOperationHandleMapConnections(lsofLocations: [LsofLocation]) {
        self.savedLsofLocations = lsofLocations
        self.addAnnotations(lsofLocations)
        self.queueOperation()
    }
    
    // DetailsView delegate callback method
    func detailsViewSelectedApp(lsofLocation: LsofLocation?) {
        if (lsofLocation != nil) {
            if (lsofLocation!.location.latitude != 0 && lsofLocation!.location.longitude != 0) {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.addAnnotation(lsofLocation!)
                self.zoomIn(lsofLocation!.location)
            }
        } else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addAnnotations(self.savedLsofLocations)
        }
    }
    
    func addAnnotations(lsofLocations: [LsofLocation]) {
        for lsofLocation in lsofLocations {
            self.addAnnotation(lsofLocation)
        }
    }
    
    func addAnnotation(lsofLocation: LsofLocation) {
        let lsof = lsofLocation.lsof
        let location = lsofLocation.location
        if (location.latitude != 0 && location.longitude != 0) {
            let metadata = lsofLocation.metadata
            let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = metadata.applicationName
            annotation.subtitle = location.locationString()
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(annotation)
            })//end main queue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        self.appView.delegates.append(self)
        self.appView.delegates.append(self.detailsView)
        
        self.detailsView.delegates.append(self.detailsView.whoisView)
        self.detailsView.delegates.append(self)
        
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