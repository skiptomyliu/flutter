//
//  AppView.swift
//  flutter
//
//  Created by Dean Liu on 2/12/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class AppView: NSView, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var tableView: NSTableView!

    
    
    /*
    
    Begin TableView delegates
    
    */
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return 10
    }
    
    func tableView(tview: NSTableView, viewForTableColumn col: NSTableColumn?, row: Int) -> NSView? {
        var cell: NSView? = tableView.makeViewWithIdentifier("appviewid", owner: self) as? NSView
        
        if cell == nil {
            cell = AppViewCell(frame: NSRect(x: 0, y: 0, width: self.tableView.frame.width, height: 25))
        }
        
//        cell?.loadItem(title: "hello", indicatorValue: relevanceValue)
        
        return cell
    }
    
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25
    }

}