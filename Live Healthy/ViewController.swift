//
//  ViewController.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import WatchConnectivity
import AWSKinesis

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var durationLabel: UILabel!
    
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (WCSession.isSupported()) {
            let session = WCSession.default
            print("This is in iPhone")
            session.delegate = self
            print("This is in View Did Load")
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("This is WCSession activated on iPhone")
        case .notActivated:
            print("This is WCSession not activated on iPhone")
        case .inactive:
            print("This is WCSession inactive on iPhone")
        default:
            print("This is default in switch on the iPhone")
        }
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session went inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value =  message["timer"] as? String {
            durationLabel.text = value;
            print(value)
        }
    }
    
    
}

