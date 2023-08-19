//
//  Protocols.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 19/08/23.
//

import Foundation

protocol FastFilterDelegate: AnyObject {
    func didClickCategoryFilter(fastFilter: FastFilterModel)
    func didClickMonthFilter()
    func selectInitialMonth()
    func didSelectMonthFilter(monthName: String)
    func didDeleteFilter(fastFilter: FastFilterModel)
}
protocol MCSelectedCategoryDelegate: AnyObject {
    func didSelectCategory(category: Category)
    func didSelectMonthButton()
}
protocol MCMonthUpdatesDelegate: AnyObject {
    func didChangeMonth(newMonthName: String)
}
protocol MCMonthSelectionDelegate: AnyObject {
    func didSelectCell(month: String) -> String
}

protocol FoodDetailDelegate: AnyObject{
    func selectFood(food: Food)
}

protocol FavoriteFoodDelegate: AnyObject {
    func didSelectFood(food: Food)
    func didSelectFavoriteButton()
}
protocol FavoritesObserver: AnyObject{
    func favoriteListDidUpdate()
}

protocol BoughtListCRUDDelegate: AnyObject {
    func getAllBoughtList(_ key: String) -> [ShoppingListModel]
    func createNewBoughtList(_ key: String, name: String?)
    func deleteBoughtList(_ key: String, idBoughtList: Int)
    func deleteAllBoughtList(_ key: String)
    func changeBoughtListStatus(_ key: String, idBoughtList: Int)
    func changeItemBoughtListStatus(_ key: String, idBoughtList: Int, idItem: Int)
    func addNewItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int)
    func removeItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int)
}
protocol BoughtListViewDelegate: AnyObject {
    func didClickCreateNew()
    func didCreateNew(name: String?)
}

protocol MCMonthNavigationButtonDelegate: AnyObject {
    func didClickMonthButton(currentMonth: String)
    func didSelectNewMonth(month: String)
}

protocol MCCategorySwipeDelegate: AnyObject {
    func didClickBackCategory()
    func didClickNextCategory()
}




