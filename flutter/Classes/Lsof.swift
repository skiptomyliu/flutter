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

struct Connection {
    var ip: IPAddress
    var network_protocol: NetworkProtocol
    var port: Int
    
    init() {
        self.ip = IPAddress(ip_str:"0.0.0.0")
        self.network_protocol = NetworkProtocol.UNDEFINED
        self.port = 0
    }
    
    init (ip: IPAddress, network_protocol: NetworkProtocol, port: Int) {
        self.ip = ip
        self.network_protocol = network_protocol
        self.port = port
    }
}

class Lsof {
    var command: String  // Application
    var pid: Int  // Process ID
    var user: String  // User associated with process
    var type: String  // Should we change this to int?
    var node: String  // TCP or UDP
    var name: String  // Raw connection string, we explode the value into src and dst address
    var ip_src: Connection = Connection()  // Parsed name to get ip src
    var ip_dst: Connection = Connection()  // Parsed name to get ip dst
    
    var description: String {
        return "\(name)"
    }
    
    init() {
        self.command = ""
        self.pid = 0
        self.user = ""
        self.type = ""
        self.node = ""
        self.name = ""
    }
    
    init(command: String, pid: Int, user: String, type: String, node: String, name: String) {
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
            self.init(command: array[0], pid: array[1].toInt()!, user: array[2], type: array[3], node: array[4], name: array[5])
        } else {
            self.init()
        }
    }
    
    // Arguments: Takes in lsof name: 172.31.99.214:59688->23.0.209.54:443
    // Returns: (Connection, Connection) tuple
    func dissect_lsof_name(lsof_name: String) -> (src_ip: Connection, dst_ip: Connection) {
        
        // Arguments:  Takes in an IP address string + port in format xxx.xxx.xxx.xxx:pp
        // Returns: (ip, port) tuple
        // XXX:  Support IPv6
        func dissect_ip_and_port(ip_and_port: String) -> (ip: IPAddress, port: Int) {
            let ip_port_array = ip_and_port.componentsSeparatedByString(":")
            if (ip_port_array.count == 2) {
                return (IPAddress(ip_str: ip_port_array[0]), ip_port_array[1].toInt()!)
            }
            return (IPAddress(ip_str: "0.0.0.0"),-1)
        }
        
        let src_dst_array = lsof_name.componentsSeparatedByString("->")
        if(src_dst_array.count > 1) {
            let src = dissect_ip_and_port(src_dst_array[0])
            let dst = dissect_ip_and_port(src_dst_array[1])
            let src_ip = Connection(ip: src.ip, network_protocol: NetworkProtocol.TCP, port: src.port)
            let dst_ip = Connection(ip: dst.ip, network_protocol: NetworkProtocol.TCP, port: dst.port)
            
            return (src_ip, dst_ip)
        }
        return (Connection(), Connection())
    }
}










