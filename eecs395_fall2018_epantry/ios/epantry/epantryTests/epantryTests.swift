//
//  epantryTests.swift
//  epantryTests
//
//  Created by Caleb Cain on 9/28/18.
//  Copyright © 2018 Caleb. All rights reserved.
//

import XCTest
@testable import epantry

class epantryTests: XCTestCase {
    
    func test_login_button() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateInitialViewController() as! LoginVC
        let _ = login.view
        XCTAssertEqual("Login", login.loginButton!.titleLabel?.text)
    }
    
     
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
