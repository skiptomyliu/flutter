//
//  LeftView.swift
//  flutter
//
//  Created by Dean Liu on 2/7/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa
import MapKit

class LeftView: NSView, ConnectionCallbackDelegate {
  
    @IBOutlet var cityCountView0: CountView!
    @IBOutlet var cityCountView1: CountView!
    @IBOutlet var cityCountView2: CountView!
    @IBOutlet var cityCountView3: CountView!
    
    @IBOutlet var countrCountView0: CountView!
    @IBOutlet var countrCountView1: CountView!
    @IBOutlet var countrCountView2: CountView!
    @IBOutlet var countrCountView3: CountView!
    
    
    var cityCountViews = [CountView]()
    var countryCountViews = [CountView]()
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func handleMapConnections(lsofLocations: [(LsofLocation)]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.cityCountViews = [self.cityCountView0,self.cityCountView1,self.cityCountView2,self.cityCountView3]
            self.countryCountViews = [self.countrCountView0, self.countrCountView1, self.countrCountView2, self.countrCountView3]
            let operationQueue = NSOperationQueue()
            
            var counterCity = [String:Int]()
            var counterCountry = [String:Int]()
            var maxCity = 0
            var maxCountry = 0
            for lsofloc in lsofLocations {
                let lsof = lsofloc.lsof
                let location = lsofloc.location
                let keyStr = "\(location.latitude)\(location.longitude)"
                let cityKey = "\(location.city)\(location.country)"
                let countryKey = "\(location.country)"
                
                counterCity[cityKey] = counterCity[cityKey] != nil ? counterCity[cityKey]!+1:1

                if (counterCity[cityKey] > maxCity) {
                    maxCity = counterCity[cityKey]!
                }
                
                counterCountry[countryKey] = counterCountry[countryKey] != nil ? counterCountry[countryKey]!+1:1
            }
            
            var i = 0
            println("dividing by \(Double(maxCity))")
            for (key,value) in counterCity {
                self.cityCountViews[i].label.stringValue = key
                self.cityCountViews[i].indicator.doubleValue = self.cityCountViews[i].indicator.doubleValue/Double(maxCity)
                if ( ++i > 3 ) {
                    i=0
                    break;
                }
            }
            for (key,value) in counterCountry {
                self.countryCountViews[i].label.stringValue = key
            }
        
        })
        
    }


}