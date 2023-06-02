//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

protocol MCMonthUpdatesDelegate: AnyObject {
    func didChangeMonth(newMonthName: String)
}

class TabBarViewController: UITabBarController {
    lazy var currentMonth = self.getCurrentMonth() {
        didSet {
            self.setupViewControllers()
        }
    }
    private var categories: [Category] = [Category]()
    
    var foods = [Food]()
         private var dataIsReceived = false
         lazy private var foodManager = FoodManager(response: {
             self.dataIsReceived = true
             self.getFoodData()
         })

    private var categoryViewController = CategoryViewController()
    private var exampleViewController = ExampleViewController()
    private var exampleSecondaryViewController = ExampleSecondaryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.setupViewControllers()
        self.setupTabItems()
        self.getFoodData()
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
        let categoryViewController = UINavigationController(rootViewController: self.categoryViewController)
        let exampleViewController = UINavigationController(rootViewController: self.exampleViewController)
        let exampleSecondaryViewController = UINavigationController(rootViewController: self.exampleSecondaryViewController)
        
        self.setViewControllers([categoryViewController, exampleViewController, exampleSecondaryViewController], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "function")
        items[2].image = UIImage(systemName: "person.circle")
    }
    
    private func setupViewControllers() {
        if !self.categories.isEmpty {
            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth)
        }
        self.exampleViewController.setup(monthUpdatesDelegate: self, currentMonth: self.currentMonth)
    }
    
    private func getFoodData() {
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.getAllCategories()
            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth)
        }
    }
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
    
    private func getAllCategories() {
        var categories = [Category]()
        for food in self.foods {
            if !categories.contains(where: {$0.id_category == food.category_food.id_category}) {
                categories.append(food.category_food)
            }
        }
        self.categories = categories
    }
}
