//
//  CategoryViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

protocol MCSelectedCategoryDelegate: AnyObject {
    func didSelectCategory(category: Category)
    func didSelectMonthButton()
}

class CategoryViewController: UIViewController {
    //MARK: - Views
    weak private var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    weak private var foodDelegate: FoodDetailDelegate? = nil
    private var categories: [Category] = [Category]()
    private var foods: [Food] = [Food]()
    var currentMonth: String = ""
    
    lazy var categoryView = CategoryView(frame: self.view.frame)
    
    override func loadView() {
        super.loadView()
        self.view = self.categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CategoryViewController: MCSelectedCategoryDelegate {
    
    func didSelectCategory(category: Category) {
        let foodViewController = FoodViewController()
        if let monthUpdatesDelegate = monthUpdatesDelegate {
            foodViewController.setup(foods: self.foods, currentMonth: self.currentMonth, monthUpdatesDelegate: monthUpdatesDelegate, category: category, categories: self.categories, foodDelegate: self.foodDelegate)
        }
        
        self.navigationController?.pushViewController(foodViewController, animated: true)
    }
    
    func didSelectMonthButton() {
        
    }
}

//MARK: - Functions
extension CategoryViewController {
    func setup(categories: [Category], monthUpdatesDelegate: MCMonthUpdatesDelegate, foods: [Food], currentMonth: String, foodDelegate: FoodDetailDelegate) {
        self.foods = foods
        self.categories = categories
        self.currentMonth = currentMonth
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.categoryView.setup(currentMonth: currentMonth)
        self.categoryView.categoryCollectionViewComponent.setup(selectedCategoryDelegate: self, categories: categories)
        self.foodDelegate = foodDelegate
    }
}
