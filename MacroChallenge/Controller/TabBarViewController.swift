//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

protocol MCMonthUpdates: AnyObject {
    func didChangeMonth(newMonthName: String)
}

class TabBarViewController: UITabBarController {
    lazy var currentMonth = self.getCurrentMonth() {
        didSet {
            self.setupViewControllers()
            self.setupTabItems()
        }
    }
    private var categoryViewController = CategoryViewController()
    private var foodViewController = FoodViewController()
    private var exampleSecondaryViewController = ExampleSecondaryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.setupViewControllers()
        self.setupTabItems()
    }
}

extension TabBarViewController: MCMonthUpdates {
    func didChangeMonth(newMonthName: String) {
        self.currentMonth = newMonthName
    }
}

//MARK: - Functions here
extension TabBarViewController {
    private func setupTabItems() {
        let categoryViewController = UINavigationController(rootViewController: self.categoryViewController)
        let exampleViewController = UINavigationController(rootViewController: self.foodViewController)
        let exampleSecondaryViewController = UINavigationController(rootViewController: self.exampleSecondaryViewController)
        
        self.setViewControllers([categoryViewController, exampleViewController, exampleSecondaryViewController], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "function")
        items[2].image = UIImage(systemName: "person.circle")
    }
    
    private func setupViewControllers() {
        //Here we set the variables that we want to pass through the controllers
//        self.exampleViewController.setup(monthUpdatesDelegate: self, currentMonth: self.currentMonth) /
        
    }
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}
