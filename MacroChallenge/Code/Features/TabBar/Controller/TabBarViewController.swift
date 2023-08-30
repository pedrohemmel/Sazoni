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
    
    private var categoryViewController = CategoryViewController()
    private var searchViewController = SearchViewController()
    private var foodViewController = FoodViewController()
    private let favoriteFoodViewController = FavoriteFoodViewController()
    private var shoppingListsViewController = ShoppingListsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        self.searchViewController.searchView.collectionView.foodDelegate = self
        self.setupViewControllers()
        self.setupTabItems()
        self.observer = FoodManager.shared.fetchFoods()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.getAllCategories()
                    self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth, foodDelegate: self)
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
        let categoryViewController = UINavigationController(rootViewController: self.categoryViewController)
        let searchViewController = UINavigationController(rootViewController: self.searchViewController)
        let favoriteFoodViewController = UINavigationController(rootViewController: self.favoriteFoodViewController)
        
        self.setViewControllers([categoryViewController, searchViewController, favoriteFoodViewController], animated: false)
        guard let items = self.tabBar.items else { return }
             
        items[0].image = UIImage(named: TabIcons.homeFillIcon)
        items[0].title = "Início"
        items[1].image = UIImage(named: TabIcons.searchIcon)
        items[1].title = "Pesquisa"
        items[2].image = UIImage(named: TabIcons.favoriteIcon)
        items[2].title = "Favoritos"
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items, let selectedItem = items.firstIndex(of: item) else {
            return
        }
        
        switch selectedItem{
        case 0:
            items[0].image = UIImage(named: TabIcons.homeFillIcon)
            items[1].image = UIImage(named: TabIcons.searchIcon)
            items[2].image = UIImage(named: TabIcons.favoriteIcon)
            
        case 1:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchFillIcon)
            items[2].image = UIImage(named: TabIcons.favoriteIcon)

            
        case 2:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchIcon)
            items[2].image = UIImage(named: TabIcons.favoriteFillIcon)
            
            
        case 3:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchIcon)
            items[2].image = UIImage(named: TabIcons.favoriteIcon)
            
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        let newTabBarWidth: CGFloat = view.frame.width + 10
        let newTabBarHeight: CGFloat = view.frame.height * 0.1
        self.tabBar.frame.size.height = newTabBarHeight
        self.tabBar.frame.size.width = newTabBarWidth
        self.tabBar.frame.origin.x = (view.frame.width - newTabBarWidth) / 2
        self.tabBar.frame.origin.y = UIScreen.main.bounds.maxY - view.frame.height * 0.080
        self.tabBar.backgroundColor = UIColor(named: "Background")
        self.tabBar.clipsToBounds = false
        self.tabBar.layer.cornerRadius = 15
        self.tabBar.layer.borderWidth = 3
        self.tabBar.layer.borderColor = UIColor.brown.cgColor
        self.tabBar.tintColor = .brown
        self.tabBar.isTranslucent = true
    }
    
    
    private func setupViewControllers() {
        if !self.categories.isEmpty {
            self.categoryViewController.setup(categories: self.categories, monthUpdatesDelegate: self, foods: self.foods, currentMonth: self.currentMonth, foodDelegate: self)
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
