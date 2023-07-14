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
        self.tabBarViewController.deleteAllBoughtList("test_bought_list")
    }
    
    func test_create_new_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        
        XCTAssertFalse(self.tabBarViewController.getAllBoughtList("test_bought_list").isEmpty)
    }
    
    func test_delete_specific_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        var boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNotNil(boughtList.firstIndex(where: { $0.id == 1 }))
        
        self.tabBarViewController.deleteBoughtList("test_bought_list", idBoughtList: 1)
        boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNil(boughtList.firstIndex(where: { $0.id == 1 }))
    }
    
    func test_delete_all_bought_lists() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        XCTAssertFalse(self.tabBarViewController.getAllBoughtList("test_bought_list").isEmpty)
        
        self.tabBarViewController.deleteAllBoughtList("test_bought_list")
        XCTAssertTrue(self.tabBarViewController.getAllBoughtList("test_bought_list").isEmpty)
    }
    
    func test_did_change_bought_list_status() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        let status = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].isClosed ///true
        self.tabBarViewController.changeBoughtListStatus("test_bought_list", idBoughtList: 0)
        let newStatus = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].isClosed ///false
        XCTAssertNotEqual(status, newStatus)
    }
    
    func test_did_change_item_bought_list_status() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.addNewItemBoughtList("test_bought_list", idBoughtList: 0, idItem: 1)
        let status = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].itemShoppingListModel[0].isBought ///false
        self.tabBarViewController.changeItemBoughtListStatus("test_bought_list", idBoughtList: 0, idItem: 1)
        let newStatus = self.tabBarViewController.getAllBoughtList("test_bought_list")[0].itemShoppingListModel[0].isBought ///true
        XCTAssertNotEqual(status, newStatus)
    }
    
    func test_add_new_item_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        var boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertTrue(boughtList[0].itemShoppingListModel.isEmpty)
        
        self.tabBarViewController.addNewItemBoughtList("test_bought_list", idBoughtList: 0, idItem: 1)
        boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertFalse(boughtList[0].itemShoppingListModel.isEmpty)
    }
    
    func test_delete_specific_item_bought_list() {
        self.tabBarViewController.createNewBoughtList("test_bought_list", name: nil)
        self.tabBarViewController.addNewItemBoughtList("test_bought_list", idBoughtList: 0, idItem: 0)
        self.tabBarViewController.addNewItemBoughtList("test_bought_list", idBoughtList: 0, idItem: 1)
        var boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNotNil(boughtList[0].itemShoppingListModel.firstIndex(where: { $0.id == 0 }))
        
        self.tabBarViewController.removeItemBoughtList("test_bought_list", idBoughtList: 0, idItem: 0)
        boughtList = self.tabBarViewController.getAllBoughtList("test_bought_list")
        XCTAssertNil(boughtList[0].itemShoppingListModel.firstIndex(where: { $0.id == 0 }))
    }

    override func tearDownWithError() throws {
        self.tabBarViewController.deleteAllBoughtList("test_bought_list")
    }
}
