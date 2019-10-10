//
//  AppDelegate.swift
//  Live Healthy
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import UIKit
import AWSS3
import AWSMobileClient
import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // Establish a run-time connection with AWS Mobile Client
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//            AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
//            AWSDDLog.sharedInstance.logLevel = .info
//            // Create AWSMobileClient to connect with AWS
//          return AWSMobileClient.default().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        self.initializeAWSConnection()
        return true
          
    }
    
    func initializeAWSConnection()  {
//        let poolID = "us-east-1:6844b08e-253d-470a-8069-62a8b10973d7"
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: poolID)
//        let configuration = AWSServiceConfiguration(region: .USEast1
//            , credentialsProvider: credentialsProvider)
//        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
//        print("Connected to AWS")
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1 , identityPoolId: "us-east-1:6844b08e-253d-470a-8069-62a8b10973d7")

        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)

        //Setup the transfer utility configuration
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = true
        tuConf.retryLimit = 5
        tuConf.timeoutIntervalForResource = 5 * 60

        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: "transfer-utility-with-advanced-options"
        ) { (error) in
             if let error = error {
                 //Handle registration error.
                print("Registration error \(error.localizedDescription)")
             }
        }

        //Look up the transfer utility object from the registry to use for your transfers.
        let transferUtility:(AWSS3TransferUtility?) = AWSS3TransferUtility.s3TransferUtility(forKey: "transfer-utility-with-advanced-options")
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

