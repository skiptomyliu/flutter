//
//  SystemCall.swift
//  flutter
//
//  Created by Dean Liu on 2/2/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation


class SystemCall {
    
    var cmd: String
    var args: Array <String>
    
    init(cmd: String, args: Array<String>) {
        self.cmd = cmd
        self.args = args
    }
    
    func run() -> String {
        let task = NSTask()
        task.launchPath = self.cmd
        task.arguments = self.args
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        
        return output
    }
    
}