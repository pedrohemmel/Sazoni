//
//  CategoryViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

protocol MCSelectedCategoryDelegate: AnyObject {
    func didSelectCategory(category: Int)
    func didSelectMonthButton()
}

class CategoryViewController: UIViewController {
    //MARK: - Views
    weak private var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    var currentMonth: String? = nil
    private var categories: [Category]? = nil
    
    var foodViewController = FoodViewController()
    
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
    func didSelectCategory(category: Int) {
        self.navigationController?.pushViewController(self.foodViewController, animated: true)
    }
    
    func didSelectMonthButton() {
        
    }
}

//MARK: - Functions
extension CategoryViewController {
    func setup(categories: [Category], monthUpdatesDelegate: MCMonthUpdatesDelegate, foods: [Food], currentMonth: String) {
        self.categories = categories
        self.currentMonth = currentMonth
        self.categoryView.setup(currentMonth: currentMonth)
        self.categoryView.categoryCollectionViewComponent.setup(selectedCategoryDelegate: self, categories: categories)
        self.foodViewController.setup(foods: foods, currentMonth: currentMonth, monthUpdatesDelegate: monthUpdatesDelegate)
    }
}
