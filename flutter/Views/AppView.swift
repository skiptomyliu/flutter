//
//  AppView.swift
//  flutter
//
//  Created by Dean Liu on 2/12/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa


protocol AppViewDelegate {
    func appViewRowSelected(lsofLocation: [LsofLocation])
}


class AppView: NSView, NSTableViewDataSource, NSTableViewDelegate, ConnectionCallbackDelegate {
    @IBOutlet var tableView: NSTableView!

    var appmetadatas = [ProcessMetadata]()
    var delegates = [AppViewDelegate]()
    var pidLsofDict = [Int: [LsofLocation]]()
    
    func connectionOperationHandleMapConnections(lsoflocations: [(LsofLocation)]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.pidLsofDict.removeAll(keepCapacity: true)
            
            for lsofLocation in lsoflocations {
                var lsof = lsofLocation.lsof
                
                if (self.containsMetadata(lsofLocation.metadata, metadatas: self.appmetadatas) == false) {
                    self.appmetadatas.append(ProcessMetadata(pid: lsof.pid))
                }
                
                if (self.pidLsofDict[lsof.pid] == nil) {
                    self.pidLsofDict[lsof.pid] = [lsofLocation]
                }else {
                    self.pidLsofDict[lsof.pid]!.append(lsofLocation)
                }
            }
            self.tableView.reloadData()
        })//end main queue
    }
    
    func containsMetadata(metadata:ProcessMetadata, metadatas:[ProcessMetadata]) -> Bool {
        for md in metadatas {
            if md.pid == metadata.pid {
                return true
            }
        }
        return false
    }
    
    /*
    
    Begin TableView delegates
    
    */
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedRow = self.tableView.selectedRow
        var lsofLocations: [LsofLocation]
        if selectedRow >= 0 {
            let selectedPid = self.appmetadatas[selectedRow].pid
            lsofLocations = self.pidLsofDict[selectedPid] ?? []
        } else { // Deselected row
            lsofLocations = []
        }
        
        for delegate in delegates {
            delegate.appViewRowSelected(lsofLocations)
        }
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return self.appmetadatas.count
    }
    
    func tableView(tview: NSTableView, viewForTableColumn col: NSTableColumn?, row: Int) -> NSView? {
        var cell: AppViewCell? = tableView.makeViewWithIdentifier("appviewid", owner: self) as? AppViewCell
        
        if cell == nil {
            cell = AppViewCell(frame: NSRect(x: 0, y: 0, width: self.tableView.frame.width, height: 25))
        }
        var metadata = self.appmetadatas[row]
        cell?.loadItem(title: metadata.applicationName, image: metadata.iconImage!)
        
        return cell
    }
    
    
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }

}