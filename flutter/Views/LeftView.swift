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
    
    // Arg:  Dictionary
    // Returns reverse sort of an array of keys based on value
    func sortDict(dict: [String:Int]) -> [String] {
        return (dict as NSDictionary).keysSortedByValueUsingComparator {
            ($1 as NSNumber).compare($0 as NSNumber)
        } as [String]
    }
    
    func handleMapConnections(lsofLocations: [(LsofLocation)]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.cityCountViews = [self.cityCountView0,self.cityCountView1,self.cityCountView2,self.cityCountView3]
            self.countryCountViews = [self.countrCountView0, self.countrCountView1, self.countrCountView2, self.countrCountView3]
            let operationQueue = NSOperationQueue()
            
            var counterCity = [String:Int]()
            var counterCountry = [String:Int]()
            
            for lsofloc in lsofLocations {
                let location = lsofloc.location
                let city = location.city != "" ? location.city : "(No City)"
                let cityKey = "\(city), \(location.country)"
                let countryKey = "\(location.country)"
                
                counterCity[cityKey] = counterCity[cityKey] != nil ? counterCity[cityKey]!+1 : 1
                counterCountry[countryKey] = counterCountry[countryKey] != nil ? counterCountry[countryKey]!+1:1
            }
            
            var i = 0
            println(counterCity)
            println(self.sortDict(counterCity))
            let sortedCityKeys = self.sortDict(counterCity)
            let maxConnectionCount = Double(counterCity[sortedCityKeys[0]]!)
            for cityKey in sortedCityKeys {
                self.cityCountViews[i].label.stringValue = cityKey
                self.cityCountViews[i].indicator.doubleValue = Double(counterCity[cityKey]!)/maxConnectionCount
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