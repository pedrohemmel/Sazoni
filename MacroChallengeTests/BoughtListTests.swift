//
//  BoughtListTests.swift
//  MacroChallengeTests
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 11/07/23.
//

import XCTest
@testable import MacroChallenge

final class BoughtListTests: XCTestCase {
    private var tabBarViewController = TabBarViewController()

    override func setUpWithError() throws {
        self.tabBarViewController.deleteAllBoughtList("test_bough_list")
    }
    
    func test_create_new_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bough_list")
        
        XCTAssertFalse(self.tabBarViewController.getAllBoughtList("test_bough_list").isEmpty)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
