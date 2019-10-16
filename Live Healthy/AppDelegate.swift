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
            tasks.append(kinesisRecorder.saveRecord(String(format: "Hello Kinesis-%02d", i).data(using: .utf8), streamName: "live-healthy-test")!)
            print(self.json)
        }
        AWSTask(forCompletionOfAllTasks: tasks).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return kinesisRecorder.submitAllRecords()
        }).continueWith(block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error{
                print("Error: \(error.localizedDescription)")
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
    
    func initializeAWSConnection()  {
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1, identityPoolId: "us-east-1:21fc92c8-6994-449d-b0cf-0cc351ba400e")
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        print("Connected to AWS")
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

