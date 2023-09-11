//
//  Protocols.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 01/09/23.
//

import Foundation

protocol MCMonthUpdatesDelegate: AnyObject {
    func didChangeMonth(newMonthName: String)
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


protocol FavoriteFoodDelegate: AnyObject {
    func didSelectFood(food: Food)
    func didSelectFavoriteButton()
}


protocol MCMonthNavigationButtonDelegate: AnyObject {
    func didClickMonthButton(currentMonth: String)
    func didSelectNewMonth(month: String)
}

protocol MCCategorySwipeDelegate: AnyObject {
    func didClickBackCategory()
    func didClickNextCategory()
}


protocol FastFilterDelegate: AnyObject {
    func didClickCategoryFilter(fastFilter: FastFilterModel)
    func didClickMonthFilter()
    func selectInitialMonth()
    func didSelectMonthFilter(monthName: String)
    func didDeleteFilter(fastFilter: FastFilterModel)
}

protocol FoodDetailDelegate: AnyObject{
    func selectFood(food: Food)
}

protocol SearchDelegate: AnyObject {
    func search(with searchText: String)
}

protocol AddFoodDelegate: AnyObject {
    func didClickAddNewFood()
}

protocol FoodToSelectDelegate: AnyObject {
    func didClickDeleteBtn(shoppingList: ShoppingListModel, food: Food)
    func didSelectFood(shoppingList: ShoppingListModel, food: Food)
    func didDeselectFood(shoppingList: ShoppingListModel, food: Food)
}
