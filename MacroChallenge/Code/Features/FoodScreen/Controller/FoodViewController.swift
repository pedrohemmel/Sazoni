protocol MCMonthNavigationButtonDelegate: AnyObject {
    func didClickMonthButton(currentMonth: String)
    func didSelectNewMonth(month: String)
}

protocol MCCategorySwipeDelegate: AnyObject {
    func didClickBackCategory()
    func didClickNextCategory()
}

import UIKit

final class FoodViewController: UIViewController {
     
     weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
     weak var foodDelegate: FoodDetailDelegate? = nil
     var currentMonth: String? = nil
     var category: Category = Category(id_category: .zero, name_category: String())
     var categories = [Category]()
     
     private lazy var foodView = FoodView(frame: self.view.frame)
     
     override func loadView() {
         super.loadView()
         self.view = foodView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.foodView.setup(currentMonth: self.currentMonth ?? "Erro mês", category: self.category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
         self.navigationItem.hidesBackButton = true
     }
 }

extension FoodViewController: MCCategorySwipeDelegate {
    func didClickBackCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        if currentCategoryIndex > 0 {
            self.category = self.categories[currentCategoryIndex - 1]
        }
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: self.category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? String())
        self.foodView.setup(currentMonth: self.currentMonth ?? "", category: category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
    func didClickNextCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        let lastIndexOfCategories = self.categories.firstIndex(where: {$0.id_category == self.categories.last?.id_category}) ?? 0
        if currentCategoryIndex < lastIndexOfCategories {
            self.category = self.categories[currentCategoryIndex + 1]
        }
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: self.category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? String())
        self.foodView.setup(currentMonth: self.currentMonth ?? String(), category: category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
}

//MARK: - Functions here
extension FoodViewController {
    func setup(currentMonth: String, monthUpdatesDelegate: MCMonthUpdatesDelegate?, category: Category, categories: [Category], foodDelegate: FoodDetailDelegate?) {
        self.currentMonth = currentMonth
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.category = category
        self.categories = categories
        self.foodDelegate = foodDelegate
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: currentMonth)
    }
    
   
    func getCurrentMonthNumber() -> Int {
        let months = Months.monthArray
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return months.firstIndex(where: {$0.lowercased() == nameOfMonth.lowercased()}) ?? 0
    }
}

