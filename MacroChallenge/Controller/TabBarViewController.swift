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

extension TabBarViewController: BoughtListCRUDDelegate {
    func getAllBoughtList(_ key: String) -> [ShoppingListModel] {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([ShoppingListModel].self, from: boughtList)
            } catch {
                print("Couldn't not save the updated boughtList.")
            }
        }
        return [ShoppingListModel]()
    }
    
    func createNewBoughtList(_ key: String, name: String?) {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                var newBoughtList = try decoder.decode([ShoppingListModel].self, from: boughtList)
                newBoughtList.append(ShoppingListModel(
                    id: newBoughtList.count,
                    name: name,
                    itemShoppingListModel: [ItemShoppingListModel](),
                    isClosed: false))
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't not save the updated boughtList.")
            }
        } else {
            do {
                let newBoughtList = [ShoppingListModel(id: 0, itemShoppingListModel: [ItemShoppingListModel](), isClosed: false)]
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't not save boughtList.")
            }
        }
    }
    
    func deleteBoughtList(_ key: String, idBoughtList: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: nil) { idBoughtList, _, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            var newBoughtList = boughtList
            if let index = newBoughtList.firstIndex(where: { $0.id == idBoughtList }) {
                newBoughtList[index].itemShoppingListModel.removeAll()
                newBoughtList.remove(at: index)
            } else {
                print("Could not find boughtList to delete.")
            }
            
            return newBoughtList
        }
    }
    
    func deleteAllBoughtList(_ key: String) {
        self.boughtListAction(key, idBoughtList: nil, idItem: nil) { _, _, boughtList in
            var newBoughtList = boughtList
            if newBoughtList.count > 0 {
                for i in 0...(newBoughtList.count - 1) {
                    newBoughtList[i].itemShoppingListModel.removeAll()
                }
            }
            newBoughtList.removeAll()
            
            return newBoughtList
        }
    }
    
    func changeBoughtListStatus(_ key: String, idBoughtList: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: nil) { idBoughtList, _, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            var newBoughtList = boughtList
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].isClosed.toggle()
            
            return newBoughtList
        }
    }
    
    func changeItemBoughtListStatus(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            var itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel[itemsShoppingListModel.firstIndex(where: { $0.id == idItem }) ?? 0].isBought.toggle()
            
            return newBoughtList
        }
    }
    
    func addNewItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel.append(ItemShoppingListModel(id: idItem, isBought: false))
            
            return newBoughtList
        }
    }
    
    func removeItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            var itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel.remove(at: itemsShoppingListModel.firstIndex(where: { $0.id == idItem }) ?? 0)
            
            return newBoughtList
        }
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
    
    private func boughtListAction(_ key: String, idBoughtList: Int?, idItem: Int?, action: @escaping ((_ idBoughtList: Int?, _ idItem: Int?, _ boughtList: [ShoppingListModel]) -> [ShoppingListModel])) {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                var newBoughtList = try decoder.decode([ShoppingListModel].self, from: boughtList)
                
                newBoughtList = action(idBoughtList, idItem, newBoughtList)
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't do this issue")
            }
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
