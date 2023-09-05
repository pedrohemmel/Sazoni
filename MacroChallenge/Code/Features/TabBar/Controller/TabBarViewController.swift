//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit
import Combine

protocol MCMonthUpdatesDelegate: AnyObject {
    func didChangeMonth(newMonthName: String)
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

class TabBarViewController: UITabBarController {
    var observer: AnyCancellable?
    lazy var currentMonth = self.getCurrentMonth()
    private var categories: [Category] = [Category]()
    private var favoriteFoods = [Food]()
    private var dataIsReceived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        FoodManager.shared.getFoods {
            self.getAllCategories()
            self.setupTabItems()
        }
    }
    
    
}

extension TabBarViewController: MCMonthUpdatesDelegate {
    func didChangeMonth(newMonthName: String) {
        self.currentMonth = newMonthName
    }
}

//MARK: - Functions here
extension TabBarViewController {

    private func setupTabItems() {
        let categoryViewController = UINavigationController(rootViewController: CategoryViewController(currentMonth: self.currentMonth, categories: self.categories, foodDelegate: self, foods: FoodManager.shared.foods))
        let favoriteFoodViewController = UINavigationController(rootViewController: FavoriteFoodViewController(currentMonth: self.currentMonth))
        let listController = UINavigationController(rootViewController: AddFoodController(foods: self.foods))
        let icon1 = UITabBarItem(title: "Início", image: .SZIconHome, selectedImage: .SZIconHomeFill)
        let icon2 = UITabBarItem(title: "Favorito", image: .SZIconFavorite, selectedImage: .SZIconFavoriteFill)
        let icon3 = UITabBarItem(title: "Lista", image: .SZIconList, selectedImage: .SZIconListFill)
        categoryViewController.tabBarItem = icon1
        favoriteFoodViewController.tabBarItem = icon2
        listController.tabBarItem = icon3
        self.setViewControllers([categoryViewController, favoriteFoodViewController, listController, ], animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        self.tabBar.backgroundColor = .SZColorSecundaryColor
        self.tabBar.tintColor = .SZColorBeige
        self.tabBar.unselectedItemTintColor = .SZColorBeige
        self.tabBar.clipsToBounds = false
        self.tabBar.isTranslucent = true
    }
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
    
    private func getAllCategories(){
        var categories = [Category]()
        for food in FoodManager.shared.foods {
            if !categories.contains(where: {$0.id_category == food.category_food.id_category}) {
                categories.append(food.category_food)
            }
        }
        self.categories = categories
    }
  
}

extension TabBarViewController: FoodDetailDelegate{
    func selectFood(food: Food) {
        self.view.endEditing(true)
        let detailVC = DetailSheetViewController(food)
        detailVC.sheetPresentationController?.detents = [.large()]
        self.present(detailVC, animated: true)
    }
}
