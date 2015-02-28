//
//  GeoIpManager.swift
//  flutter
//
//  Created by Dean Liu on 2/3/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

/*

Blocks
startIpNum,endIpNum,locId

Location:
locId,country,region,city,postalCode,latitude,longitude,metroCode,areaCode

*/

import Foundation

struct Location {
    var locId: Int          //Location ID
    var country: String
    var region: String
    var city: String
    var postalCode: String
    var latitude: Double
    var longitude: Double
    var metroCode: Int?
    var areaCode: Int?
    
    func locationString() -> String{
        if self.city != "" {
            return "\(self.city), \(self.region)"
        }
        let locale = NSLocale.currentLocale()
        let displayStr = locale.displayNameForKey(NSLocaleCountryCode, value: self.country)
        if displayStr == nil {
            return ""
        } else {
            return displayStr!
        }
    }
}

class GeoIpManager{
    var database: FMDatabase
    
    init(){
        let db_path = NSBundle.mainBundle().pathForResource("locations", ofType: "db")
        self.database = FMDatabase(path: db_path)
        if !self.database.open() {
            println("Unable to open database")
            return
        }
    }
    
    func parseLsofRaw(lines: String) -> [Location] {
        var locations = [Location]()
        let lines = lines.componentsSeparatedByString("\n")
        for line in lines{
            let lsof = Lsof(raw_line: line, delimiter: "~")
            let loc = self.region_from_ipaddress(lsof.ip_dst.ip)
            if loc != nil {
                println("\(loc?.city) - (\(loc?.latitude),\(loc?.longitude)) \(loc?.city) \(loc?.country)  ")
                locations.append(loc!)
            }
        }
        return locations
    }
    
    func region_from_ipaddress(ipaddress: IPAddress) -> Location? {
        let location_id = self.locId_from_ip(ipaddress.ip_int()!)
        return self.region_from_locid(location_id)
    }
    
    // Arguments:  Provide IP Address and retrieve the location id from Blocks DB
    // Return:  Location ID associated with IP Address block
    private func locId_from_ip(ipaddress: Int) -> Int {
        if let rs = self.database.executeQuery("SELECT locId FROM blocks WHERE startIpNum <= \(ipaddress) AND endIpNum >= \(ipaddress);", withArgumentsInArray: nil) {
            while rs.next() {
                return rs.stringForColumn("locId").toInt()!
            }
        }
        return 0
    }
    
    // Arguments:  Given a location id (from Blocks DB), we fetch the location metadata
    // Return:  Location object
    private func region_from_locid(locId: Int) -> Location? {
        if let rs = self.database.executeQuery("SELECT * FROM location WHERE locId = \(locId);", withArgumentsInArray: nil) {
            while rs.next() {
                let locId = rs.stringForColumn("locId").toInt()!
                let country = rs.stringForColumn("country")
                let region = rs.stringForColumn("region")
                let city = rs.stringForColumn("city") != nil ? rs.stringForColumn("city") : ""
                let postalCode = rs.stringForColumn("postalCode")
                let latitude = rs.doubleForColumn("latitude");
                let longitude = rs.doubleForColumn("longitude")
                let metroCode:Int? = rs.stringForColumn("metroCode").toInt()
                let areaCode:Int? = rs.stringForColumn("areaCode").toInt()
                return Location(locId: locId, country: country, region: region, city: city, postalCode: postalCode, latitude: latitude, longitude: longitude, metroCode: metroCode, areaCode: areaCode)
            }
        }
        return nil
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