//
//  IPAddress.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation

class IPAddress {
    var ip: String = "0.0.0.0"
    
    init(ip_str: String) {
        self.ip = ip_str
    }
    
    func ip_int() -> Int? {
        let ip_components_array = self.ip.componentsSeparatedByString(".")
        
        if (ip_components_array.count == 4){
            let ip_comp1: Int = ip_components_array[0].toInt()!
            let ip_comp2: Int = ip_components_array[1].toInt()!
            let ip_comp3: Int = ip_components_array[2].toInt()!
            let ip_comp4: Int = ip_components_array[3].toInt()!
            
            return ip_comp1 << 24 + ip_comp2 << 16 + ip_comp3 << 8 + ip_comp4
        }
        return nil
    }
    
    func isIp6() -> Bool {
        // XXX:  Todo
        return false
    }
}

func == (lhs: IPAddress, rhs: IPAddress) -> Bool {
    return lhs.ip == rhs.ip
}