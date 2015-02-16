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
    func appRowSelected(lsofLocation: [LsofLocation])
}


class AppView: NSView, NSTableViewDataSource, NSTableViewDelegate, ConnectionCallbackDelegate {
    @IBOutlet var tableView: NSTableView!

    var appmetadatas = [ProcessMetadata]()
//    var pidsList = [(Int)]() //XXX:  Change this to use native Sets after SDK upates
    var delegate: AppViewDelegate?
    var pidLsofDict = [Int: [LsofLocation]]()
    
    func handleMapConnections(lsoflocations: [(LsofLocation)]) {
        for lsofLocation in lsoflocations {
            var lsof = lsofLocation.lsof
            
            if (contains(self.pidLsofDict.keys, lsof.pid) == false) {
                self.appmetadatas.append(ProcessMetadata(pid: lsof.pid))
            }
            
            if (self.pidLsofDict[lsof.pid] == nil) {
                self.pidLsofDict[lsof.pid] = [lsofLocation]
            }else {
                self.pidLsofDict[lsof.pid]!.append(lsofLocation)
            }
        }
        
//        println(self.pidLsofDict)
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })//end main queue
    }
    
    /*
    
    Begin TableView delegates
    
    */
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedRow = self.tableView.selectedRow
        if (selectedRow != -1) {
            let selectedPid = self.appmetadatas[selectedRow].pid
            
            delegate?.appRowSelected( self.pidLsofDict[selectedPid]! )
            //Update Details Screen
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