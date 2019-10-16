//
//  AppDelegate.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSKinesis

@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //This is the JSON String with xyz coordinates (only passive data)
    var json: String = ViewController().generateJSON();
    
    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /** Initialize and push data to Kinesis Stream*/
        print("Initializing Mobile Client")
        AWSController().initializeAWSConnection()
                AWSMobileClient.default().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
            }
        }
        let kinesisRecorder = AWSKinesisRecorder.default()
//        kinesisRecorder.saveRecord(json, streamName: <#T##String!#>)
        // Create an array to store a batch of objects.
        var tasks = Array<AWSTask<AnyObject>>()
        for i in 0...100 {
            tasks.append(kinesisRecorder.saveRecord(String(format: "Hello Kinesis-%02d", i).data(using: .utf8), streamName: "live-healthy-test")!)
            print("Json test \(self.json)")
        }
        AWSTask(forCompletionOfAllTasks: tasks).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return kinesisRecorder.submitAllRecords()
        }).continueWith(block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error{
                // Will get  Error Domain=com.amazonaws.AWSCognitoIdentityErrorDomain Code=10 if the userpoolId does not have a valid stream name.
                print("Error: \(error)")
            }
            else{
                print("Data pushed to Stream")
                print(tasks)
            }
            return nil
        })
        kinesisRecorder.submitAllRecords()
        /**End of push data to Kinesis Stream*/
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return AWSMobileClient.default().interceptApplication(
            application, open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}

