//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit
import Combine

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
        let listController = UINavigationController(rootViewController: ShoppingListsViewController())
        let icon1 = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let icon2 = UITabBarItem(title: "Favorito", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        let icon3 = UITabBarItem(title: "Lista", image: UIImage(systemName: "list.bullet.clipboard"), selectedImage: UIImage(systemName: "list.bullet.clipboard.fill"))
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
