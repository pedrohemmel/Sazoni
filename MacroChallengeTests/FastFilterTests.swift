//
//  FastFilterTests.swift
//  MacroChallengeTests
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 20/06/23.
//

import XCTest
@testable import MacroChallenge

final class FastFilterTests: XCTestCase {
    var searchViewController = SearchViewController()
    
    //Testing if all foods are filtered by fished category
    func testSelectionFastFilter() {
        ///self.searchViewController.fastFilters[1] same of  FastFilterModel(name: "fruits", idCategory: 0, filterIsSelected: false)
        self.searchViewController.didClickCategoryFilter(fastFilter: self.searchViewController.fastFilters[1])
        
        XCTAssert(self.searchViewController.choosenFilters[0].name == self.searchViewController.fastFilters[1].name)
        
        var isFruit = true
        for filteredFood in self.searchViewController.filteredFoods {
            if filteredFood.category_food.id_category != self.searchViewController.choosenFilters[0].idCategory {
                isFruit = false
            }
        }
        
        XCTAssert(isFruit)
    }
}
