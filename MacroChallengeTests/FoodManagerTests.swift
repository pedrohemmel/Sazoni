//
//  FoodManagerTests.swift
//  MacroChallengeTests
//
//  Created by Well on 30/05/23.
//

import XCTest
@testable import MacroChallenge
final class FoodManagerTests: XCTestCase {
    private var foods = [Food]()
    private var dataIsReceived = false
    lazy private var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.setupAdditionalConfiguration()
    })
    
    func testReceivedData() {
        self.setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {
        if !self.dataIsReceived {
            XCTAssert(foods.isEmpty)
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            XCTAssert(!foods.isEmpty)
        }
    }
}
