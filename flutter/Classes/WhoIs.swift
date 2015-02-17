//
//  WhoIs.swift
//  flutter
//
//  Created by Dean Liu on 2/17/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation

class WhoIs {
    var ip: IPAddress
    var data: String
    
    init(ip: IPAddress) {
        self.ip = ip
        let whoisPath = NSBundle.mainBundle().pathForResource("whois", ofType: "sh")
        self.data = SystemCall(cmd: whoisPath!, args: [ip.ip]).run()
    }
}