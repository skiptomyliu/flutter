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
    @IBOutlet var leftView: NSView?
    
    var uniqueLocationDict = [String: Int]()
    let operationQueue = NSOperationQueue()
    
    var counterCity = [String:Int]()
    var counterCountry = [String:Int]()
    
    func handleMapConnections(lsofLocations: [(LsofLocation)]) {
        
        for lsofLocation in lsofLocations {
            let lsof = lsofLocation.lsof
            let location = lsofLocation.location
            
            let keyStr = "\(location.latitude)\(location.longitude)"
            
            let citykey = "\(location.city)\(location.country)"
            let countryKey = "\(location.country)"
            
            counterCity[citykey] = counterCity[citykey] != nil ? counterCity[citykey]!+1:1
            counterCountry[countryKey] = counterCountry[countryKey] != nil ? counterCountry[countryKey]!+1:1
            
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
        
        println(counterCity)
        println(counterCountry)
        
        counterCountry = [String:Int]()
        counterCity = [String:Int]()
        
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