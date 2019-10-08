//  ViewController.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreMotion

@available(iOS 13.0, *)
class ViewController: UIViewController, WCSessionDelegate {
    
//    var motionManager: CMMotionManager!
//    var gravityStr: String!
//    var userAccelStr:String!
//    var rotationRateStr:String!
//    var attitudeStr:String!
    
   
    @IBOutlet weak var durationLabel: UILabel!
    
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
//            //MotionManager
//            motionManager = CMMotionManager()
//            motionManager.deviceMotionUpdateInterval = 1.0 / 50
//            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion: CMDeviceMotion?, error: Error?) in
//                    if error != nil {
//                       print("Encountered error: \(error!)")
//                    }
//                    if deviceMotion != nil {
//                       self.processDeviceMotion(deviceMotion!)
//                    }
//                }
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
    
//    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
//        // 1. These strings are to show on the UI. Trying to fit
//        // x,y,z values for the sensors is difficult so we’re
//        // just going with one decimal point precision.
//        gravityStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
//                            deviceMotion.gravity.x,
//                            deviceMotion.gravity.y,
//                            deviceMotion.gravity.z)
//        userAccelStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
//                           deviceMotion.userAcceleration.x,
//                           deviceMotion.userAcceleration.y,
//                           deviceMotion.userAcceleration.z)
//        rotationRateStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
//                              deviceMotion.rotationRate.x,
//                              deviceMotion.rotationRate.y,
//                              deviceMotion.rotationRate.z)
//        attitudeStr = String(format: "r: %.1f p: %.1f y: %.1f" ,
//                                 deviceMotion.attitude.roll,
//                                 deviceMotion.attitude.pitch,
//                                 deviceMotion.attitude.yaw)
//
//        durationLabel.text = String(deviceMotion.userAcceleration.x)
//
//    }
}




