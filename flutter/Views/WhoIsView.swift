//
//  WhoIsView.swift
//  flutter
//
//  Created by Dean Liu on 2/17/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class WhoIsView: NSView, DetailsViewDelegate {
    @IBOutlet var scrollview: NSScrollView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var view: NSView!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        NSColor.redColor().setFill()
        NSRectFill(dirtyRect);
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NSBundle.mainBundle().loadNibNamed("WhoIsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        self.frame = contentFrame
        self.addSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSBundle.mainBundle().loadNibNamed("WhoIsView", owner: self, topLevelObjects: nil)
        self.addSubview(self.view)
    }
    
    
    
    // DetailsView delegate
    func detailsViewSelectedApp(lsofLocation: LsofLocation?) {
        if (lsofLocation != nil) {
            let whois = WhoIs(ip: lsofLocation!.lsof.ip_dst.ip)
            self.textView.string = whois.data
        }
    }
}

