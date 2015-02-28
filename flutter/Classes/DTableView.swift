//
//  DTableView.swift
//  flutter
//
//  Created by Dean Liu on 2/27/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//
/*
    Overriding mouseDown event on NSTableView so rows are automatically deselected
*/
import Foundation
import Cocoa

class DTableView: NSTableView {
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        println("mouse down is happening")
        var point = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        var row = self.rowAtPoint(point)
        
        if (row == -1) {
            self.deselectAll(nil)
        }
    }
}