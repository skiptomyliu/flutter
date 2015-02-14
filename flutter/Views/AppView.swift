//
//  AppView.swift
//  flutter
//
//  Created by Dean Liu on 2/12/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class AppView: NSView, NSTableViewDataSource, NSTableViewDelegate, ConnectionCallbackDelegate {
    @IBOutlet var tableView: NSTableView!

    var appmetadatas = [ProcessMetadata]()
    var pidsList = [(String)]() //XXX:  Change this to use native Sets after SDK upates
    
    func handleMapConnections(lsoflocations: [(LsofLocation)]) {
        for lsofLocation in lsoflocations {
            var lsof = lsofLocation.lsof
            
            if (contains(self.pidsList, lsof.pid) == false) {
                self.pidsList.append(lsof.pid)
                self.appmetadatas.append(ProcessMetadata(pid: lsof.pid))
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })//end main queue
    }
    
    /*
    
    Begin TableView delegates
    
    */
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
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        println("notification: \(notification)")
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 32
    }

}