//  ViewController.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreMotion
import HealthKit

@available(iOS 13.0, *)
class ViewController: UIViewController, WCSessionDelegate {
    
    let healthStore = HKHealthStore();
    
    var motionManager: CMMotionManager!
    var gravityStr: String!
    var userAccelStr:String!
    var rotationRateStr:String!
    var attitudeStr:String!
    
   
    @IBOutlet weak var getStepsButton: UIButton!
    @IBOutlet weak var enableHealthAccessButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            //Rounded
            self.getStepsButton.layer.cornerRadius = 10;
            self.enableHealthAccessButton.layer.cornerRadius = 10;
            
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
        durationLabel.text = String(gravityStr)
    }
    
    @IBAction func authoriseHealthKitAccess(_ sender: Any) {
           let healthKitTypes: Set = [
               // access step count
               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
           ]
           healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
               if let e = error {
                   print("oops something went wrong during authorisation \(e.localizedDescription)")
               } else {
                   print("User has completed the authorization flow")
               }
           }
       }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
           
           let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
           
           let now = Date()
           let startOfDay = Calendar.current.startOfDay(for: now)
           let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
           
           let stepsQuery = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
               var resultCount = 0.0
               guard let result = result else {
                   print("Failed to fetch steps rate")
                   completion(resultCount)
                   return
               }
               if let sum = result.sumQuantity() {
                   resultCount = sum.doubleValue(for: HKUnit.count())
               }
               DispatchQueue.main.async {
                   completion(resultCount)
               }
           }
           healthStore.execute(stepsQuery)
       }
       
       @IBAction func getTotalSteps(_ sender: Any) {
           getTodaysSteps { (result) in
               print("\(result)")
               DispatchQueue.main.async {
                   self.stepLabel.text = "Steps: \(result)"
               }
           }
       }
}




