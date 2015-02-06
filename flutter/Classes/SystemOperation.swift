//
//  SystemOperation.swift
//  flutter
//
//  Created by Dean Liu on 2/5/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation

class SystemOperation: NSOperation {

    let systemCall: SystemCall
    
    init(systemCall: SystemCall) {
        self.systemCall = systemCall
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        self.systemCall.run()
    }
}

