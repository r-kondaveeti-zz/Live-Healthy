//
//  AppDelegate.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore
import AWSKinesis


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    // Establish a run-time connection with AWS Mobile Client
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /** Initialize and push data to Kinesis Stream*/
        initializeAWSConnection()
        AWSMobileClient.default().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
            }
        }
        let kinesisRecorder = AWSKinesisRecorder.default()
        // Create an array to store a batch of objects.
        var tasks = Array<AWSTask<AnyObject>>()
        for i in 0...100 {
            tasks.append(kinesisRecorder.saveRecord(String(format: "Hello Kinesis-%02d", i).data(using: .utf8), streamName: "live-health-input")!)
        }
        AWSTask(forCompletionOfAllTasks: tasks).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return kinesisRecorder.submitAllRecords()
        }).continueWith(block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error{
                print("Error: \(error.localizedDescription)")
            }
            return nil
        })
        kinesisRecorder.submitAllRecords()
        /**End of push data to Kinesis Stream*/
        return true
        
    }
    
    func initializeAWSConnection()  {
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1, identityPoolId: "")
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        print("Connected to AWS")
        
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
}

