//
//  AppDelegate.swift
//  flutter
//
//  Created by Dean Liu on 2/2/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let lsof_path = NSBundle.mainBundle().pathForResource("lsof", ofType: "sh")
        println(lsof_path)
        let sc = SystemCall(cmd: lsof_path!, args: []);
        let result = sc.run()
        let lines = result.componentsSeparatedByString("\n");
        
        for line in lines{
            let lsof = Lsof(raw_line: line, delimiter: "~")
            println ("\(lsof.name) \(lsof.command)")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

