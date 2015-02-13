//
//  SystemObject.swift
//  flutter
//
//  Created by Dean Liu on 2/12/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

/*

From PID get additional assets:

- Application icon
- Application path

*/
import Foundation
import Cocoa


class ProcessMetadata {
    var applicationPath: String = ""
    var iconImage: NSImage?
    
    init(pid: String) {
        let psPath = NSBundle.mainBundle().pathForResource("ps", ofType: "sh")
        let rawAppPath:NSString = SystemCall(cmd: psPath!, args: [pid]).run()
        self.initAppPath(rawAppPath)
        self.initIconImage()
    }
    
    private func initAppPath(rawCommandPath: String) {
        let components = rawCommandPath.componentsSeparatedByString("/") as [String]
        var pathCount = 0
        for (index, component) in enumerate(components) {
            if (component.hasSuffix(".app")) {
                pathCount = index
                break;
            }
        }
        self.applicationPath = "/".join(components[0...pathCount])
    }
    
    private func initIconImage() {
        let contentsPath = "\(self.applicationPath)/Contents/"
        let myDict = NSDictionary(contentsOfFile: "\(contentsPath)/Info.plist")
        var icon: String? = myDict?.objectForKey("CFBundleIconFile") as? String
        if icon?.hasSuffix(".icns") == false {
            icon! += ".icns"
        }
        if icon != nil {
            var icnPath = "\(contentsPath)Resources/\(icon!)"
            var image: NSImage = NSWorkspace.sharedWorkspace().iconForFile(icnPath)
            self.iconImage = NSImage(contentsOfFile: icnPath)
            self.iconImage?.size = NSMakeSize(32, 32)
        }
    }
}