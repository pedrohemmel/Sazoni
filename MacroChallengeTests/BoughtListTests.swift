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
    
    func test_delete_specific_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        var boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNotNil(boughtList.firstIndex(where: { $0.id == 1 }))
        
        self.tabBarViewController.deleteBoughtList("test_bought_list", idBoughtList: 1)
        boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNil(boughtList.firstIndex(where: { $0.id == 1 }))
    }
    
    func test_delete_all_bought_lists() {
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        XCTAssertFalse(self.tabBarViewController.getAllBoughtList("test_bought_list").isEmpty)
        
        self.tabBarViewController.deleteAllBoughtList("test_bought_list")
        XCTAssertTrue(self.tabBarViewController.getAllBoughtList("test_bought_list").isEmpty)
    }
    
    func test_did_change_bought_list_status() {
        self.tabBarViewController.createNewBoughtList("test_bought_list")
        let status = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].isClosed ///true
        self.tabBarViewController.changeBoughtListStatus("test_bought_list", idBoughtList: 0)
        let newStatus = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].isClosed ///false
        XCTAssertNotEqual(status, newStatus)
    }

    override func tearDownWithError() throws {
        self.tabBarViewController.deleteAllBoughtList("test_bough_list")
    }
}
