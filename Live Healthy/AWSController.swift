//
//  AWSController.swift
//  Live Healthy
//
//  Created by Khanh Luu on 10/16/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import Foundation
import AWSMobileClient
@available(iOS 13.0, *)
class AWSController {
    func initializeAWSConnection()  {
        //Setup credentials, see your awsconfiguration.json for the "YOUR-IDENTITY-POOL-ID"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1, identityPoolId: "us-east-1:7098dcc8-a4c0-4114-b4a5-414610b54e8a")
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        print("Connected to AWS")
    }
}
