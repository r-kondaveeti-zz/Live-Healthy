//
//  AWSController.swift
//  Live Healthy
//
//  Created by Khanh Luu on 10/16/19.
//  Copyright © 2019 Yash Tech. All rights reserved.

import Foundation
import AWSMobileClient
import AWSKinesis
@available(iOS 13.0, *)
class AWSController {
    
    init() {
        self.initializeAWSConnection()
    }
    
   
    func initializeAWSConnection()  {
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1, identityPoolId: "us-east-1:94c0ca1c-86df-4d2b-83c4-25240b8b8102")
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        print("Connected to AWS")
    }
    
    func saveRecord(_ json: String)  {
        let kinesisRecorder = AWSKinesisRecorder.default()
        // Create an array to store a batch of objects.
        var tasks = Array<AWSTask<AnyObject>>()
        print("This is in save record, \(json)")
        tasks.append(kinesisRecorder.saveRecord(String(json).data(using: .utf8), streamName: "yash-live-healthy-kinesis-stream"))
        AWSTask(forCompletionOfAllTasks: tasks).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return kinesisRecorder.submitAllRecords()
        }).continueWith(block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error{
                // Will get  Error Domain=com.amazonaws.AWSCognitoIdentityErrorDomain Code=10 if the userpoolId does not have a valid stream name.
                print("Error: \(error)")
            }
            else{
                print("Data pushed to Stream")
                print("Task: \(tasks)")
            }
            return nil
        })
        kinesisRecorder.submitAllRecords()
    }
}
