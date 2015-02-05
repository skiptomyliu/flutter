//
//  Lsof.swift
//  flutter
//
//  Created by Dean Liu on 2/2/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

/*

    Parse lsof line and store its results in class properties

*/

import Foundation

enum NetworkProtocol {
    case TCP, UDP, UNDEFINED
}

struct IPAddress {
    var ip: String
    var network_protocol: NetworkProtocol
    var port: Int
    
    init() {
        self.ip = ""
        self.network_protocol = NetworkProtocol.UNDEFINED
        self.port = 0
    }
    
    init (ip: String, network_protocol: NetworkProtocol, port: Int) {
        self.ip = ip
        self.network_protocol = network_protocol
        self.port = port
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

class Lsof {
    var command: String  // Application
    var pid: String  // Process ID
    var user: String  // User associated with process
    var type: String  // Should we change this to int?
    var node: String  // TCP or UDP
    var name: String  // Raw connection string, we explode the value into src and dst address
    var ip_src: IPAddress = IPAddress()  // Parsed name to get ip src
    var ip_dst: IPAddress = IPAddress()  // Parsed name to get ip dst
    
    init() {
        self.command = ""
        self.pid = ""
        self.user = ""
        self.type = ""
        self.node = ""
        self.name = ""
    }
    
    init(command: String, pid: String, user: String, type: String, node: String, name: String) {
        self.command = command
        self.pid = pid
        self.user = user
        self.type = type
        self.node = node
        self.name = name
        
        let lsof_parsed_src_dst = self.dissect_lsof_name(self.name)
        self.ip_src = lsof_parsed_src_dst.src_ip
        self.ip_dst = lsof_parsed_src_dst.dst_ip
    }
    
    convenience init(raw_line: String, delimiter: String) {
        let array = raw_line.componentsSeparatedByString(delimiter)
        if(array.count >= 5) {
            self.init(command: array[0], pid: array[1], user: array[2], type: array[3], node: array[4], name: array[5])
        } else {
            self.init()
        }
    }
    
    // Arguments:  Takes in an IP address + port in format xxx.xxx.xxx.xxx:pp
    // Returns: (ip, port) tuple
    // XXX:  Support IPv6
    func dissect_ip_and_port(ip_and_port: String) -> (ip: String, port: Int) {
        let ip_port_array = ip_and_port.componentsSeparatedByString(":")
        if (ip_port_array.count == 2) {
            return (ip_port_array[0], ip_port_array[1].toInt()!)
        }
        return ("",-1)
    }
    
    // Arguments: Takes in lsof name: 172.31.99.214:59688->23.0.209.54:443
    // Returns: (IPAddress, IPAddress) tuple
    func dissect_lsof_name(lsof_name: String) -> (src_ip: IPAddress, dst_ip: IPAddress) {
        let src_dst_array = lsof_name.componentsSeparatedByString("->")
        
        if(src_dst_array.count > 1) {
            let src = dissect_ip_and_port(src_dst_array[0])
            let dst = dissect_ip_and_port(src_dst_array[1])
            let src_ip = IPAddress(ip: src.ip, network_protocol: NetworkProtocol.TCP, port: src.port)
            let dst_ip = IPAddress(ip: dst.ip, network_protocol: NetworkProtocol.TCP, port: dst.port)
            
            return (src_ip, dst_ip)
        }
        return (IPAddress(), IPAddress())
    }
}