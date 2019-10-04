//
//  SwimmingInterfaceController.swift
//  Live Healthy WatchKit Extension
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import WatchKit
import Foundation


class SwimmingInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func didPressSwimming() {
        pop()
    }
    
}
