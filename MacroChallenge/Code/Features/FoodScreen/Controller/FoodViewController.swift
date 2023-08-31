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
     var foods = [Food]()
     var category: Category = Category(id_category: .zero, name_category: String())
     var categories = [Category]()
     var filteredFoods = [Food]()
     
     private lazy var foodView = FoodView(frame: self.view.frame)
     
     override func loadView() {
         super.loadView()
         self.view = foodView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.foodView.setup(foods: self.filteredFoods, currentMonth: self.currentMonth ?? "Erro mês", category: self.category, monthButtonDelegate: self, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
         self.navigationItem.hidesBackButton = true
     }
 }

extension FoodViewController: MCMonthNavigationButtonDelegate {
    func didClickMonthButton(currentMonth: String) {
        let newVC = MonthSelectionViewController()
        newVC.delegate = self
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    func didSelectNewMonth(month: String) {
        self.monthUpdatesDelegate?.didChangeMonth(newMonthName: month)
        self.filteredFoods = self.filterFoods(foods: foods, category: category, currentMonth: month)
    
        self.foodView.setup(foods: self.filteredFoods, currentMonth: month, category: category, monthButtonDelegate: self, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
}

extension FoodViewController: MCCategorySwipeDelegate {
    func didClickBackCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        if currentCategoryIndex > 0 {
            self.category = self.categories[currentCategoryIndex - 1]
        }
        self.filteredFoods = self.filterFoods(foods: foods, category: category, currentMonth: self.currentMonth ?? "")
        self.foodView.setup(foods: self.filteredFoods, currentMonth: self.currentMonth ?? "", category: category, monthButtonDelegate: self, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
    func didClickNextCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        let lastIndexOfCategories = self.categories.firstIndex(where: {$0.id_category == self.categories.last?.id_category}) ?? 0
        if currentCategoryIndex < lastIndexOfCategories {
            self.category = self.categories[currentCategoryIndex + 1]
        }
        self.filteredFoods = self.filterFoods(foods: foods, category: category, currentMonth: self.currentMonth ?? "")
        self.foodView.setup(foods: self.filteredFoods, currentMonth: self.currentMonth ?? "", category: category, monthButtonDelegate: self, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
}

//MARK: - Functions here
extension FoodViewController {
    func setup(foods: [Food], currentMonth: String, monthUpdatesDelegate: MCMonthUpdatesDelegate?, category: Category, categories: [Category], foodDelegate: FoodDetailDelegate?) {
        self.foods = foods
        self.currentMonth = currentMonth
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.category = category
        self.categories = categories
        self.foodDelegate = foodDelegate
        self.filteredFoods = self.filterFoods(foods: foods, category: category, currentMonth: currentMonth)
    }
    
    func filterFoods(foods: [Food], category: Category, currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        newFoods = self.filterFoodsByCategory(foods: foods, category: category)
        newFoods = self.orderFoodsByHighQualityInCurrentMonth(foods: newFoods, currentMonth: currentMonth)
        return newFoods
    }
    func filterFoodsByCategory(foods: [Food], category: Category) -> [Food] {
        return foods.filter({ food in
            return food.category_food.id_category == category.id_category
        })
    }
    func orderFoodsByHighQualityInCurrentMonth(foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Alta", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Média", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Baixa", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Muito baixa", foods: foods, currentMonth: currentMonth))
        return newFoods
    }
    
    func getFoodsInCurrentMonthWithState(state: String, foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        for food in foods {
            for seasonality in food.seasonalities {
                if seasonality.month_name_seasonality.lowercased() == currentMonth.lowercased() {
                    if seasonality.state_seasonality.lowercased() == state.lowercased() {
                        newFoods.append(food)
                    }
                }
            }
        }
        newFoods = newFoods.sorted(by: { $0.name_food < $1.name_food })
        return newFoods
    }
}

