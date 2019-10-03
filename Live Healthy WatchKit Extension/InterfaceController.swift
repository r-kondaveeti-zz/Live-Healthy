//
//  InterfaceController.swift
//  Live Healthy WatchKit Extension
//
//  Created by Radithya Reddy on 10/2/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var startStopButtonStatus: Bool = true;
    
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func didPressStartStopButton() {
        if startStopButtonStatus {
            startStopButton.setTitle("Stop");
            startStopButtonStatus = !startStopButtonStatus;
        } else {
            startStopButton.setTitle("Start");
            startStopButtonStatus = !startStopButtonStatus;
        }
    }
    
}
