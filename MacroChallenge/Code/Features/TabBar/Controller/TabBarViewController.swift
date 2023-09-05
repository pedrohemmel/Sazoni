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
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        let favoriteFoodViewController = UINavigationController(rootViewController: FavoriteFoodViewController(currentMonth: self.currentMonth))
        let shoppingListsViewController = UINavigationController(rootViewController: ShoppingListsViewController())
        self.setViewControllers([categoryViewController, searchViewController, favoriteFoodViewController, shoppingListsViewController], animated: false)
        guard let items = self.tabBar.items else { return }
             
        items[0].image = UIImage(named: TabIcons.homeFillIcon)
        items[0].title = "Início"
        items[1].image = UIImage(named: TabIcons.searchIcon)
        items[1].title = "Pesquisa"
        items[2].image = UIImage(named: TabIcons.favoriteIcon)
        items[2].title = "Favoritos"
        items[3].image = UIImage(named: TabIcons.listIcon)
        items[3].title = "Lista"
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
            items[3].image = UIImage(named: TabIcons.listIcon)
        case 1:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchFillIcon)
            items[2].image = UIImage(named: TabIcons.favoriteIcon)
            items[3].image = UIImage(named: TabIcons.listIcon)
        case 2:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchIcon)
            items[2].image = UIImage(named: TabIcons.favoriteFillIcon)
            items[3].image = UIImage(named: TabIcons.listIcon)
        case 3:
            items[0].image = UIImage(named: TabIcons.homeIcon)
            items[1].image = UIImage(named: TabIcons.searchIcon)
            items[2].image = UIImage(named: TabIcons.favoriteIcon)
            items[3].image = UIImage(named: TabIcons.listFillIcon)
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
