//
//  AppViewCell.swift
//  flutter
//
//  Created by Dean Liu on 2/12/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class AppViewCell: NSTableCellView {

    @IBOutlet var view: NSView!
    
    func loadItem(#title: String, image: NSImage) {
        self.textField?.stringValue = title
        self.imageView?.image = image
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NSBundle.mainBundle().loadNibNamed("AppViewCell", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("AppViewCell", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }
}