//
//  DependentOperation.swift
//  flutter
//
//  Created by Dean Liu on 2/6/15.
//  Copyright (c) 2015 dragonfly. All rights reserved.
//

/*

This wraps an NSOperation and sets another NSOperation to run after it is finished

Revisit this later

*/
import Foundation

protocol CallbackDelegate {
    func handle_lsof(lines_raw: String)
    func handle_geolocations(locations: [Location])
}

class DependentOperation: NSOperation {
    var run: (() -> AnyObject?)?
    var run_arg: ((String) -> [AnyObject]?)?
    var callback: CallbackDelegate?
    var arguments: AnyObject?
    
    var dependentOperation: DependentOperation?
    var output: AnyObject?
    
    init(run_method: () -> AnyObject?) {
        self.run = run_method
    }
    
    init(run_arg: ((String) -> [AnyObject]?), arguments: AnyObject){
        self.run_arg = run_arg
        self.arguments = arguments
    }
    
    init(run_arg: ((String) -> [AnyObject]?), dependentOperation: DependentOperation){
        self.run_arg = run_arg
        self.dependentOperation = dependentOperation
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        assert(self.run != nil && self.run_arg != nil, "run and run_arg cannot be nil!")
        if self.run != nil {
            self.output = self.run!()
            if self.callback != nil {
//                self.callback!.handle_input(self.output)
            }
            
        } else {
//            self.output = self.run_arg!(self.dependentOperation!.output!)
        }
        println("The output: \(self.output)")
    }
}
