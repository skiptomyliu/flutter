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
    @IBOutlet var appView: AppView!
    @IBOutlet var detailsView: DetailsView!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    
    var uniqueLocationDict = [String: Int]()
    let operationQueue = NSOperationQueue()
    var savedLsofLocations = [LsofLocation]()
    
    let MIN_SPAN = 1.0
    
    // AppView delegate callback method
    func appViewRowSelected(lsofLocations: [LsofLocation]) {
        /* load the details of the app and show only locations pertaining to selected app */
        self.mapView.removeAnnotations(self.mapView.annotations)
        if lsofLocations.count > 0 {
            self.addAnnotations(lsofLocations)
        } else {
            self.addAnnotations(self.savedLsofLocations)
        }
        self.zoomToFitMapAnnotations()
    }
    
    func zoomIn(location: Location) {
        let span = MKCoordinateSpan(latitudeDelta: self.MIN_SPAN, longitudeDelta: self.MIN_SPAN)
        let coord = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region = MKCoordinateRegion(center: coord, span: span)
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.regionThatFits(region)
    }
    
    func zoomToFitMapAnnotations() {
        dispatch_async(dispatch_get_main_queue(), {
            if self.mapView.annotations.count <= 0 {
                return
            }
            
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in self.mapView.annotations {
                topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
                topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
                
                bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
                bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            }
            
            var coord = CLLocationCoordinate2D(
                latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5,
                longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
            )

            var span = MKCoordinateSpan(
                latitudeDelta: fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2,
                longitudeDelta: fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
            )
            
            // If only one point, then we add some padding, otherwise it zooms at max level
            if (span.latitudeDelta <= 0 && span.longitudeDelta <= 0 ) {
                span.latitudeDelta = self.MIN_SPAN
                span.longitudeDelta = self.MIN_SPAN
            }
            
            var region = MKCoordinateRegion(center: coord, span: span)
            region = self.mapView.regionThatFits(region)
            self.mapView.setRegion(region, animated: false)
        })
    }
    
    // ConnectionOperations delegate callback method
    func connectionOperationHandleMapConnections(lsofLocations: [LsofLocation]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.progressIndicator.stopAnimation(self)
            self.progressIndicator.hidden = true
            self.savedLsofLocations = lsofLocations
            self.addAnnotations(lsofLocations)
            // self.queueOperation() // Temporarily disable recalling the queueoperation
        })
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
        co.threadPriority = 0.01
        co.queuePriority = NSOperationQueuePriority.VeryLow
        co.qualityOfService = NSQualityOfService.Background
        co.delegates.append(self)
        co.delegates.append(self.appView)
        operationQueue.addOperations([co], waitUntilFinished: false)
        
        
        self.progressIndicator.startAnimation(self)
        self.progressIndicator.hidden = false
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}