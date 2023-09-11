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
    lazy var currentMonth = self.getCurrentMonth() {
        didSet {
            self.setupViewControllers()
        }
    }
    private var categories: [Category] = [Category]()
    private let favorite = FavoriteList.shared
    private var foods = [Food]()
    private var favoriteFoods = [Food]()
    private var dataIsReceived = false
    private let favoriteFoodViewController = FavoriteFoodViewController()
    private var shoppingListsViewController = ShoppingListsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        self.setupViewControllers()
        
        self.observer = FoodManager.shared.fetchFoods()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.getAllCategories()
                    self.setupTabItems()
                    self.favoriteFoodViewController.setup(food: self.foods, currentMonth: self.currentMonth)
                    
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { (foods) in
                self.foods = foods
            })
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
            let itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
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
            let itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel.remove(at: itemsShoppingListModel.firstIndex(where: { $0.id == idItem }) ?? 0)
            
            return newBoughtList
        }
    }
}

//MARK: - Functions here
extension TabBarViewController {

    private func setupTabItems() {
        let categoryViewController = UINavigationController(rootViewController: CategoryViewController(currentMonth: self.currentMonth, categories: self.categories, foodDelegate: self, foods: self.foods))
        let favoriteFoodViewController = UINavigationController(rootViewController: self.favoriteFoodViewController)
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
        self.tabBar.unselectedItemTintColor = .red
        self.tabBar.clipsToBounds = false
        self.tabBar.isTranslucent = true
    }
    
    
    private func setupViewControllers() {
        if !self.categories.isEmpty {
            
//            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth, foodDelegate: self)
        }
        
        self.shoppingListsViewController.boughtListCRUDDelegate = self
        self.shoppingListsViewController.setup(boughtList: self.getAllBoughtList("boughtList"))
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
        self.view.endEditing(true)
        let detailVC = DetailSheetViewController(food)
        detailVC.sheetPresentationController?.detents = [.large()]
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
        if self.favoriteFoodViewController.isViewLoaded {
            self.favoriteFoodViewController.favoriteFoodView.collectionView.setup(foods: listFavoriteFood, currentMonth: self.currentMonth, foodDelegate: nil, favoriteFoodDelegate: self.favoriteFoodViewController)
            }
        }
        
}
