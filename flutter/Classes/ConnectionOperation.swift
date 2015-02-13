//
//  SystemOperation.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation


protocol ConnectionCallbackDelegate {
    func handleMapConnections([(LsofLocation)])
}

class ConnectionOperation: NSOperation {
    var delegates = [ConnectionCallbackDelegate]()
    let delay:NSTimeInterval = 10 //XXX:  Todo, put this in plist
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let lsof_path = NSBundle.mainBundle().pathForResource("lsof", ofType: "sh")
        let result = SystemCall(cmd: lsof_path!, args: []).run()
        let lines = result.componentsSeparatedByString("\n");
        
        let geoip = GeoIpManager()
        var mapConnections = [LsofLocation]()
        for line in lines{
            if (line.isEmpty == false) {
                let lsof = Lsof(raw_line: line, delimiter: "~")
                let ps_path = NSBundle.mainBundle().pathForResource("ps", ofType: "sh")
                let metadata = ProcessMetadata(pid: lsof.pid)
                let loc = geoip.region_from_ipaddress(lsof.ip_dst.ip)
                
                if loc != nil {
                    mapConnections.append(LsofLocation(location: loc!, lsof: lsof, metadata: metadata))
                }
            }
        }
        
        for delegate in delegates {
            delegate.handleMapConnections(mapConnections)
        }
        NSThread.sleepForTimeInterval(self.delay)
    }
}

