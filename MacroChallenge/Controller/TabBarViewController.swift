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

protocol FavoritesObserver: AnyObject{
    func favoriteListDidUpdate()
}


class TabBarViewController: UITabBarController {
    
    lazy var currentMonth = self.getCurrentMonth() {
        didSet {
            self.setupViewControllers()
        }
    }
    private var categories: [Category] = [Category]()
    private let favorite = FavoriteList.shared
    
    var foods = [Food]()
    var favoriteFoods = [Food]()
    private var dataIsReceived = false
    lazy private var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.getFoodData()
    })
    
    private var categoryViewController = CategoryViewController()
    private var exampleViewController = SearchViewController()
    private var foodViewController = FoodViewController()
    private let favoriteFoodViewController = FavoriteFoodViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.cornerRadius = 10
        self.tabBar.addTopBorder(color: .brown, height: 3)
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.tintColor = .brown
        self.tabBar.backgroundColor = UIColor(named: "Background")
        self.tabBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor(named: "Background")
        
        self.exampleViewController.searchView.collectionView.foodDelegate = self
        self.setupViewControllers()
        self.setupTabItems()
        self.getFoodData()
        self.favorite.registerObserver(self)
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
        let exampleSecondaryViewController = UINavigationController(rootViewController: self.favoriteFoodViewController)
        
        self.setViewControllers([categoryViewController, exampleViewController, exampleSecondaryViewController], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "magnifyingglass")
        items[2].image = UIImage(systemName: "star")
    }
    
    private func setupViewControllers() {
        if !self.categories.isEmpty {
            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth, foodDelegate: self)
        }
    }
    
    private func getFoodData() {
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.favoriteFoods = getAllFavoriteFood(list: foods)
            self.getAllCategories()
            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth, foodDelegate: self)
            self.favoriteFoodViewController.setup(food: self.favoriteFoods, currentMonth: self.currentMonth, foodDelegate: self)
        }
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
        for food in self.foods {
            if !categories.contains(where: {$0.id_category == food.category_food.id_category}) {
                categories.append(food.category_food)
            }
        }
        self.categories = categories
    }
    
    func getAllFavoriteFood(list: [Food])->[Food]{
        let listFavorite = UserDefaults.standard.array(forKey: "favorite") as? [Int]
        var listFavoriteFood = [Food]()
        if let favoriteFood = listFavorite {
            for id in favoriteFood {
                for food in list {
                    if id == food.id_food {
                        listFavoriteFood.append(food)
                    }
                }
            }
        }
        return listFavoriteFood
    }
    
    
}

extension TabBarViewController: FoodDetailDelegate{
    func selectFood(food: Food) {
        let detailVC = DetailSheetViewController(food)
        detailVC.sheetPresentationController?.detents = [.large()]
        detailVC.sheetPresentationController?.prefersGrabberVisible = true
        self.present(detailVC, animated: true)
    }
}


extension TabBarViewController: FavoritesObserver{
    func favoriteListDidUpdate(){
        let listFavorite = UserDefaults.standard.array(forKey: "favorite") as? [Int]
        var listFavoriteFood = [Food]()
        if let favoriteFood = listFavorite {
            for id in favoriteFood {
                for food in self.foods {
                    if id == food.id_food {
                        listFavoriteFood.append(food)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.favoriteFoodViewController.favoriteFoodView.collectionView.setup(foods: listFavoriteFood, currentMonth: self.currentMonth, foodDelegate: self)
        }
    }
    
}
