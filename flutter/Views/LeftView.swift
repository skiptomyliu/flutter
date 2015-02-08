//
//  LeftView.swift
//  flutter
//
//  Created by Dean Liu on 2/7/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class LeftView: NSView {
  
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
//        NSColor.blackColor().colorWithAlphaComponent(0.2).setFill()
//        NSRectFill(dirtyRect)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
       

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        for i in 1...5 {
            var indicator = NSLevelIndicator()
            indicator.levelIndicatorStyle = NSLevelIndicatorStyle.RelevancyLevelIndicatorStyle
            indicator.doubleValue = 1.0
            indicator.frame = NSRect(x: 25, y: 25*i, width:500, height:20)
            self.addSubview(indicator)
        }
        
    }
}