//
//  DetailsView.swift
//  flutter
//
//  Created by Dean Liu on 2/16/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

protocol DetailsViewDelegate {
    func detailsViewSelectedApp(lsofLocation: LsofLocation)
}

class DetailsView: NSView, AppViewDelegate, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var view: NSView!
    @IBOutlet var whoisView: WhoIsView!
    
    var delegate: DetailsViewDelegate?
    var lsofLocations = [LsofLocation]()
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.delegate = self.whoisView
        NSBundle.mainBundle().loadNibNamed("DetailsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        self.frame = contentFrame
        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self.whoisView
        NSBundle.mainBundle().loadNibNamed("DetailsView", owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    // Delegate function from AppView
    func appViewRowSelected(lsofLocations: [LsofLocation]) {
        self.lsofLocations = lsofLocations
        self.tableView.reloadData()
    }
    
    /*
    
    Begin TableView delegates
    
    */
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedRow = self.tableView.selectedRow
        if (selectedRow >= 0) {
            self.delegate = self.whoisView
            self.delegate?.detailsViewSelectedApp(self.lsofLocations[selectedRow])
        }
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return lsofLocations.count
    }
    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!{
        let lsofObj = self.lsofLocations[row].lsof
        return "\(lsofObj.ip_dst.ip.ip):\(lsofObj.ip_dst.port)"
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25
    }

    
}