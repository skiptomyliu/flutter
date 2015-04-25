//
//  LeftView.swift
//  flutter
//
//  Created by Dean Liu on 2/7/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa
import MapKit

class SummaryView: NSVisualEffectView, NSTableViewDataSource, NSTableViewDelegate, ConnectionCallbackDelegate, AppViewDelegate {
    @IBOutlet var tableView: NSTableView!
    
    // Suspected compiler bug, need to typealias because it doesn't recognize it in the array without
    typealias cityRelevance = (key: String, relevance: Double)
    var cityRelevanceList: [cityRelevance] = []
    var countryCountViews = [CountView]()   //delete
    
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
    
    /*
    
    Begin Delegates
    
    */
    
    func appViewRowSelected(lsofLocations: [LsofLocation]) {
        /* load the details of the app */
        println("row: \(lsofLocations)")
    }
    
    // ConnectionCallbackDelegate
    func connectionOperationHandleMapConnections(lsofLocations: [(LsofLocation)]) {
        var counterCity = [String:Int]()
        for lsofloc in lsofLocations {
            var location = lsofloc.location
            var cityKey = location.locationString()
            var countryKey = "\(location.country)"
            
            counterCity[cityKey] = counterCity[cityKey] != nil ? counterCity[cityKey]!+1 : 1
        }
        
        // Sort the connections
        let sortedCityKeys = self.sortDict(counterCity)
        let maxConnectionCount = Double(counterCity[sortedCityKeys[0]]!)
        self.cityRelevanceList.removeAll(keepCapacity: true)
        for cityKey in sortedCityKeys {
            self.cityRelevanceList.append((cityKey, Double(counterCity[cityKey]!)/maxConnectionCount))
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })//end main queue
    }
    
    /* 
    
    Begin TableView delegates
    
    */
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return cityRelevanceList.count
    }
    
    func tableView(tview: NSTableView, viewForTableColumn col: NSTableColumn?, row: Int) -> NSView? {
        var (title, relevanceValue) = cityRelevanceList[row]
        var cell: CountView? = tableView.makeViewWithIdentifier("countviewid", owner: self) as? CountView
        
        if cell == nil {
            cell = CountView(frame: NSRect(x: 0, y: 0, width: self.tableView.frame.width, height: 25))
        }
        cell?.loadItem(title: title, indicatorValue: relevanceValue)

        return cell
    }
    
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25
    }
    
}