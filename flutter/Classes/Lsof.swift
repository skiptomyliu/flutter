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

class Lsof {
    var command: String     // Application
    var pid: String
    var user: String
    var type: String        // Should we change this to int?
    var node: String        // TCP or UDP
    var name: String        // The raw connection string
    
    var ip_src: String?     // Parsed name to get ip src
    var ip_dst: String?     // Parsed name to get ip dst
    
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
    }
    
    convenience init(raw_line: String, delimiter: String) {
        let array = raw_line.componentsSeparatedByString(delimiter)
        if(array.count >= 5) {
            self.init(command: array[0], pid: array[1], user: array[2], type: array[3], node: array[4], name: array[5])
        } else {
            self.init()
        }
    }

}