//
//  CountView.swift
//  flutter
//
//  Created by Dean Liu on 2/9/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class CountView: NSTableCellView {
    @IBOutlet var label: NSTextField!
    @IBOutlet var indicator: NSLevelIndicator!
    @IBOutlet var view: NSView!
    
    
    func loadItem(#title: String, indicatorValue: Double) {
        self.label.stringValue = title
        self.indicator.doubleValue = indicatorValue
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    convenience init(frame frameRect: NSRect, title: String, fillPercentage: Double) {
        self.init(frame: frameRect)
        self.indicator.doubleValue = fillPercentage
        self.label.stringValue = title
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NSBundle.mainBundle().loadNibNamed("CountViewCell", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("CountViewCell", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }
}