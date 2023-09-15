//
//  MonthSelectionTests.swift
//  MacroChallengeTests
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import XCTest
@testable import MacroChallenge

final class MonthSelectionTests: XCTestCase {
    private var tabBarViewController = TabBarViewController()
    private var mainViewController = FoodViewController()
    private var monthSelectionViewController = MonthSelectionViewController()
    
    func testDelegateOfSelectedMonth() {
        self.tabBarViewController.currentMonth = "Julho"
        XCTAssert(self.mainViewController.currentMonth == "Julho")
        XCTAssert(self.tabBarViewController.currentMonth == "Julho")
        
        self.monthSelectionViewController.delegate = mainViewController
        self.monthSelectionViewController.delegate?.didSelectNewMonth(month: "Abril")
        XCTAssert(self.mainViewController.currentMonth == "Abril")
        XCTAssert(self.tabBarViewController.currentMonth == "Abril")
        
        
    }
}
