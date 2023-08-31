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
    
    init(currentMonth: String, categories: [Category], foodDelegate: FoodDetailDelegate) {
        self.categories = categories
        self.currentMonth = currentMonth
        self.foodDelegate = foodDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    weak var foodDelegate: FoodDetailDelegate? = nil
    private var categories: [Category] = [Category]()
    private var foods: [Food] = [Food]()
    var currentMonth: String
    
    lazy var categoryView = CategoryView(frame: self.view.frame, currentMonth: currentMonth, categories: categories)
    
    override func loadView() {
        super.loadView()
        self.view = self.categoryView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.categoryCollectionViewComponent.selectedCategoryDelegate = self
    }
}

extension CategoryViewController: MCSelectedCategoryDelegate {
    
    func didSelectCategory(category: Category) {
        let foodViewController = FoodViewController()
        if let foodDelegate = self.foodDelegate {
            foodViewController.setup(foods: self.foods, currentMonth: self.currentMonth, monthUpdatesDelegate: nil, category: category, categories: self.categories, foodDelegate: foodDelegate)
        }
        
        self.navigationController?.pushViewController(foodViewController, animated: true)
    }
    
    func didSelectMonthButton() {
        
    }
}

//MARK: - Functions
extension CategoryViewController {
//    func setup(categories: [Category], monthUpdatesDelegate: MCMonthUpdatesDelegate, foods: [Food], currentMonth: String, foodDelegate: FoodDetailDelegate) {
//        self.foods = foods
//        self.categories = categories
//        self.monthUpdatesDelegate = monthUpdatesDelegate
//        self.categoryView.categoryCollectionViewComponent.setup(selectedCategoryDelegate: self, categories: categories)
//        self.foodDelegate = foodDelegate
//    }
}
