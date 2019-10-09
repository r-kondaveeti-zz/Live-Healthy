//
//  AWSManager.swift
//  Live Healthy
//
//  Created by Khanh Luu on 10/9/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import Foundation
import UIKit
import AWSS3

typealias progressBlock = (_ progess: Double) -> Void
typealias completionBlock = (_ response: Any?,_ error: Error? ) -> Void
class AWSManager {
    static let shared = AWSManager()
    
    private init(){}
    let bucketName = "live-healthy-s3bucket-dev"
    
    //Upload file to S3
    func uploadFile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Uploading using AWS3Utility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith{(task) -> Any? in
            if let erorr = task.error {
                print("Erorr in \(erorr.localizedDescription)")
            }
            if let _ = task.result {
                print("Uploaded file successful")
            }
            return nil
        }
    }
}
