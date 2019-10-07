//
//  Live_HealthyUITests.swift
//  Live HealthyUITests
//
//  Created by Nolan Schoenle on 10/7/19.
//  Copyright © 2019 Yash Tech. All rights reserved.
//

import XCTest

class Live_HealthyUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp();
        app = XCUIApplication();
        app.launch();

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate();
        super.tearDown();
    }

    func test_titleDoesAppear_phoneApp() {
        let app_title = app.staticTexts["Live Healthy"];
        
        XCTAssertTrue(app_title.exists);
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
