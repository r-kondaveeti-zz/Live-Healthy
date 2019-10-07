//
//  Live_HealthyUITests.swift
//  Live HealthyUITests
//
//  Created by Nolan Schoenle on 10/7/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import XCTest
import WatchConnectivity

class Live_HealthyUITests: XCTestCase {
    var app: XCUIApplication!;
    let APP_TITLE = "Live Healthy";
    let DURATION_LABEL_START_TEXT = "Label";
    
    
    override func setUp() {
        
        super.setUp();
        
        continueAfterFailure = false
        
        //Launch the app
        app = XCUIApplication();
        app.launch();
    }

    override func tearDown() {
       
        app.terminate();
        super.tearDown();
    }

    func test_titleDoesAppear_phoneApp() {
        let app_title = app.staticTexts[APP_TITLE];
        
        XCTAssertTrue(app_title.exists);
    }
    
    func test_durationLabelAppearsBeforeAnyDataSent_phoneApp(){
        let app_durationLabel = app.staticTexts[DURATION_LABEL_START_TEXT];
        XCTAssertTrue(app_durationLabel.exists);
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
