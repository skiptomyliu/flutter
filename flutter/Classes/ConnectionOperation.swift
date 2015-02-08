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
    var delegate: ConnectionCallbackDelegate?
    let delay:NSTimeInterval = 10 //XXX:  Todo, put this in plist
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let lsof_path = NSBundle.mainBundle().pathForResource("lsof", ofType: "sh")
        let sc = SystemCall(cmd: lsof_path!, args: []);
        let result = sc.run()
        let lines = result.componentsSeparatedByString("\n");
        
        let geoip = GeoIpManager()
        var mapConnections = [LsofLocation]()
        for line in lines{
            println(line)
            let lsof = Lsof(raw_line: line, delimiter: "~")
            let loc = geoip.region_from_ipaddress(lsof.ip_dst.ip)
            if loc != nil {
                mapConnections.append(LsofLocation(location: loc!, lsof: lsof))
            }
        }
        delegate?.handleMapConnections(mapConnections)
        NSThread.sleepForTimeInterval(self.delay)
    }
}

