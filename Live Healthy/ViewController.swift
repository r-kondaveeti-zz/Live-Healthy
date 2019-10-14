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
import AWSMobileClient

@available(iOS 13.0, *)
class ViewController: UIViewController, WCSessionDelegate {
    
    let healthStore = HKHealthStore();
    let cornerRadius : CGFloat = 15.0
   
    
    @IBOutlet weak var backGroundLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logOutLabel: UIButton!
    @IBOutlet weak var mealTimerLabel: UILabel!
    @IBOutlet weak var accelerometerLabel: UILabel!
    @IBOutlet weak var getStepsButton: UIButton!
    @IBOutlet weak var enableHealthAccessButton: UIButton!
    
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoLabel.layer.shadowColor = UIColor.black.cgColor
        self.infoLabel.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.infoLabel.layer.shadowRadius = 5
        self.infoLabel.layer.shadowOpacity = 1.0
        
        self.backGroundLabel.clipsToBounds = true
        self.backGroundLabel.layer.cornerRadius = 10;
        self.logOutLabel.layer.cornerRadius = 10;
  
        
        //Initialize AWSMobileClient
        initializeAWSMobileClient()
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            }
        
        }
    
    func initializeAWSMobileClient() {
        AWSMobileClient.default().initialize{ (UserState, error) in
            if let userState = UserState {
            switch(UserState) {
            case .signedIn:
                print("Logged In")
                print("Cognito Identity Id (authenticated): \(AWSMobileClient.default().identityId!)")
                
            case .signedOut:
                print("Logged Out")
                DispatchQueue.main.async {
                    self.showSignIn()
                    }
            case .signedOutUserPoolsTokenInvalid:
                print("User Pools refresh token is invalid or expired")
                DispatchQueue.main.async {
                    self.showSignIn()
                }
            default:
                AWSMobileClient.default().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func showSignIn() {
        AWSMobileClient.default().showSignIn(navigationController: self.navigationController!, {
            (userState, error) in
            if(error == nil) {
                DispatchQueue.main.async {
                    print("User successfully logged in")
                }
            }
        })
    }
    
//    func showSignOut() {
//        AWSMobileClient.default().signOut()
//    }
    
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
        DispatchQueue.main.async {
                // update label
                if let mealValue =  message["timer"] as? String {
                print("This is in session on iPhone")
                self.mealTimerLabel.text = mealValue;
                print(mealValue)
            }
        }
        
        DispatchQueue.main.async {
                if let accelerometerValue = message["accelerometer"] as? String {
                // Run UI Updates
                // update label
                self.accelerometerLabel.text = accelerometerValue;
            }
        }
    }
    
//    @IBAction func authoriseHealthKitAccess(_ sender: Any) {
//           let healthKitTypes: Set = [
//               // access step count
//               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
//               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
//           ]
//           healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
//               if let e = error {
//                   print("oops something went wrong during authorisation \(e.localizedDescription)")
//               } else {
//                   print("User has completed the authorization flow")
//               }
//           }
//       }
    
//    func getTodaysSteps(completion: @escaping (Double) -> Void) {
//
//           let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//
//           let now = Date()
//           let startOfDay = Calendar.current.startOfDay(for: now)
//           let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//           let stepsQuery = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
//               var resultCount = 0.0
//               guard let result = result else {
//                   print("Failed to fetch steps rate")
//                   completion(resultCount)
//                   return
//               }
//               if let sum = result.sumQuantity() {
//                   resultCount = sum.doubleValue(for: HKUnit.count())
//               }
//               DispatchQueue.main.async {
//                   completion(resultCount)
//               }
//           }
//           healthStore.execute(stepsQuery)
//       }
//
//       @IBAction func getTotalSteps(_ sender: Any) {
//           getTodaysSteps { (result) in
//               print("\(result)")
//               DispatchQueue.main.async {
//                   self.stepLabel.text = "Steps: \(result)"
//               }
//           }
//       }
    
    @IBAction func didPressLogOut(_ sender: Any) {
        AWSMobileClient.default().signOut()
        self.showSignIn()
    }
        
    
}




