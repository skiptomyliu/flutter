//
//  PreferencesViewController.swift
//  flutter
//
//  Created by Dean Liu on 4/25/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

import Foundation
import Cocoa


class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var refreshRateLabel: NSTextField!
    
    
    @IBAction func sliderValueChanged(sender: NSSlider) {
        println(sender.integerValue)
        
        self.refreshRateLabel.stringValue = "\(String(sender.integerValue)) seconds"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.integerValue, forKey: "refreshLimit")
        
        
    }
}
