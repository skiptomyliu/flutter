//
//  SystemOperation.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation


protocol ConnectionCallbackDelegate {
    func handleConnections([Location])
}

class ConnectionOperation: NSOperation {
    var delegate: ConnectionCallbackDelegate?
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let lsof_path = NSBundle.mainBundle().pathForResource("lsof", ofType: "sh")
        let sc = SystemCall(cmd: lsof_path!, args: []);
        let result = sc.run()
        let lines = result.componentsSeparatedByString("\n");
        
        let geoip = GeoIpManager()
        let locations = geoip.parseLsofRaw(result)
        for location in locations {
            println(location)
        }
        delegate?.handleConnections(locations)
    }
}

