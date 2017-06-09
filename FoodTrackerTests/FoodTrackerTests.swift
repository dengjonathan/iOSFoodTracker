//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Jonathan Deng on 5/21/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
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
    
    // MARK: Meal class tests
    func testMealInitSucceeds() {
        let zeroMeal = Meal.init(name: "zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroMeal)
        let fiveMeal = Meal.init(name: "five", photo: nil, rating: 5)
        XCTAssertNotNil(fiveMeal)
    }
    
    func testMealFails() {
        let negativeMeal = Meal.init(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeMeal)
        
        let noName = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName)
        
        let aboveMax = Meal.init(name: "above", photo: nil, rating: 100)
        XCTAssertNil((aboveMax))
    }
}
