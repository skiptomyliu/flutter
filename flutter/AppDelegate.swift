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
        let sc = SystemCall(cmd: lsof_path!, args: []);
//        let result = sc.run()
//        let lines = result.componentsSeparatedByString("\n");
//        
//        let geomanager = GeoIpManager()
//        for line in lines{
//            let lsof = Lsof(raw_line: line, delimiter: "~")
//            let loc = geomanager.region_from_ipaddress(lsof.ip_dst.ip)
//            println("\(loc?.city) - (\(loc?.latitude),\(loc?.longitude)) \(loc?.city) \(loc?.country)  ")
//        }
        
        
        // XXX: Change the system calls to bg
        // Separate the shell script fetch 
        // Add background operation to depend on shell script result
        let backgroundOperation: NSOperation = NSOperation()
        backgroundOperation.queuePriority = NSOperationQueuePriority.Low
        backgroundOperation.qualityOfService = NSQualityOfService.Background
        let lsofOperation: SystemOperation = SystemOperation(systemCall: sc)
        
        let geoOperation: NSOperation = NSOperation()
        geoOperation.addDependency(lsofOperation)
        
        let operationQueue = NSOperationQueue.mainQueue()
        operationQueue.addOperations([lsofOperation, geoOperation], waitUntilFinished: false)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

