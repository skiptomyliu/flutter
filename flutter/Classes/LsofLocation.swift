//
//  LsofLocation.swift
//  flutter
//
//  Created by Dean Liu on 2/7/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation

class LsofLocation {
    var location: Location
    var lsof: Lsof
    var metadata: ProcessMetadata
    
    init(location: Location, lsof: Lsof, metadata: ProcessMetadata) {
        self.location = location
        self.lsof = lsof
        self.metadata = metadata
    }
    
    var description: String {
        return "Location \(location)\n Lsof: \(lsof)"
    }
}