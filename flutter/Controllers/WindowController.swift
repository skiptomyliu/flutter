//
//  WindowController.swift
//  flutter
//
//  Created by Dean Liu on 3/11/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa

class WindowController:  NSWindowController, NSWindowDelegate {
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize {
        return frameSize
    }
    
}