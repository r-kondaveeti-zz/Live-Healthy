//
//  RunningInterfaceController.swift
//  Live Healthy WatchKit Extension
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class RunningInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var motionManager: CMMotionManager!
    var gravityStr: String!
    var userAccelStr:String!
    var rotationRateStr:String!
    var attitudeStr:String!
    
    var totalTime = 0.0;
    
    //Session between iPhone and Apple Watch
    let session = WCSession.default;
    
    @IBOutlet weak var axisX: WKInterfaceButton!
    @IBOutlet weak var axisY: WKInterfaceButton!
    @IBOutlet weak var axisZ: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let session = WCSession.default
        session.delegate = self;
        session.activate()
        //MotionManager
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 1.0 / 50
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                if error != nil {
                   print("Encountered error: \(error!)")
                }
                if deviceMotion != nil {
                   self.processDeviceMotion(deviceMotion!)
                }
            }
        }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func didPressRunning() {
        pop()
    }
    
    func messageToPhone() {
        if WCSession.default.isReachable {
            session.sendMessage(["timer": String(format: "%.1f", totalTime)], replyHandler: nil, errorHandler: nil)
             print("This is sending message to the phone ")
        }
    }

    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        // 1. These strings are to show on the UI. Trying to fit
        // x,y,z values for the sensors is difficult so we’re
        // just going with one decimal point precision.
        gravityStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                            deviceMotion.gravity.x,
                            deviceMotion.gravity.y,
                            deviceMotion.gravity.z)
        userAccelStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                           deviceMotion.userAcceleration.x,
                           deviceMotion.userAcceleration.y,
                           deviceMotion.userAcceleration.z)
        rotationRateStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                              deviceMotion.rotationRate.x,
                              deviceMotion.rotationRate.y,
                              deviceMotion.rotationRate.z)
        attitudeStr = String(format: "r: %.1f p: %.1f y: %.1f" ,
                                 deviceMotion.attitude.roll,
                                 deviceMotion.attitude.pitch,
                                 deviceMotion.attitude.yaw)
        
        axisX.setTitle(String(deviceMotion.userAcceleration.x))
        totalTime = deviceMotion.userAcceleration.x;
        axisY.setTitle(String(deviceMotion.userAcceleration.y))
        axisZ.setTitle(String(deviceMotion.userAcceleration.z))
        
        self.messageToPhone();
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Watch WC Session activated")
        case .notActivated:
            print("Watch WC Session not activated")
        case .inactive:
            print("Watch WC Session inactivate")
        @unknown default:
            print("This is the default switch case on the Apple Watch")
        }
    }
}
