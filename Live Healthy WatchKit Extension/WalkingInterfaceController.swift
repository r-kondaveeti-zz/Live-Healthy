//
//  RunningInterfaceController.swift
//  Live Healthy WatchKit Extension
//
//  Created by Radithya Reddy on 10/3/19.
//  Copyright © 2019 Yash Tech. All rights reserved.

import WatchKit
import Foundation
import WatchConnectivity



class WalkingInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let session = WCSession.default;
    
    var message: [String: String] {
              return ["timer": "0.07"]
          }
          
    func messageToPhone() {
           if WCSession.default.isReachable {
               session.sendMessage(message, replyHandler: nil, errorHandler: nil)
                print("This is sending message to the phone ")
           }
       }
    
    @IBOutlet weak var timerLabel: WKInterfaceLabel!
    var timerIsRunning = false;
    var counter = 0.0;
    var totalTime = 0.0;
    var timer = Timer();
    
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    var startStopButtonStatus: Bool = true;

       override func awake(withContext context: Any?) {
           super.awake(withContext: context)
           print("This is in Apple Watch")
           let session = WCSession.default
           session.delegate = self;
           session.activate()
       }

       override func willActivate() {
           super.willActivate()
       }

       override func didDeactivate() {
           super.didDeactivate()
       }
       
    @IBAction func didPressDismiss() {
        pop()
    }
    
    @IBAction func didPressStartStop() {
            if startStopButtonStatus {
                startStopButton.setTitle("Stop");
                messageToPhone();
                startStopButtonStatus = !startStopButtonStatus;
                if !timerIsRunning {
                timerLabel.setText(String(counter));
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(WalkingInterfaceController.updateTimer), userInfo: nil, repeats: true);
                timerIsRunning = true;
                }
            } else {
                startStopButton.setTitle("Start");
                startStopButtonStatus = !startStopButtonStatus;
                timer.invalidate()
                timerIsRunning = false;
                messageToPhone();
                counter = 0.0;
                timerLabel.setText(String(format: "%.1f", totalTime));
            }
    }
    
    @objc func updateTimer() {
        counter = counter + 0.1;
        totalTime = totalTime + 0.1;
        timerLabel.setText(String(format: "%.1f", counter));
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
