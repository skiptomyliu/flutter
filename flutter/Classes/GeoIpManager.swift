//
//  GeoIpManager.swift
//  flutter
//
//  Created by Dean Liu on 2/3/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation

class GeoIpManager{
    
    var database: FMDatabase
    
    init(){
        self.database = FMDatabase(path: "/tmp/locations.db")
    }
    
    func test(){
        if !self.database.open() {
            println("Unable to open database")
            return
        }
        
        if let rs = self.database.executeQuery("SELECT country, region FROM Location LIMIT 10", withArgumentsInArray: nil) {
            while rs.next() {
                let x = rs.stringForColumn("country")
                let y = rs.stringForColumn("region")
                println("x = \(x); y = \(y);")
            }
        } else {
        println("select failed: \(self.database.lastErrorMessage())")
        }
    }

}