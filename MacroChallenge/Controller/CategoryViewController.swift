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
    
    var exampleViewController = ExampleViewController()
    
    lazy var categoryView = CategoryView(frame: self.view.frame)
    
    override func loadView() {
        super.loadView()
        self.view = self.categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryView.categoryCollectionViewComponent.setup(selectedCategoryDelegate: self)
    }
}

extension CategoryViewController: MCSelectedCategoryDelegate {
    func didSelectCategory(category: Int) {
        self.navigationController?.pushViewController(exampleViewController, animated: true)
    }
    
    func didSelectMonthButton() {
        
    }
}

//MARK: - Functions
extension CategoryViewController {
    func setup(monthUpdatesDelegate: MCMonthUpdatesDelegate, currentMonth: String) {
        self.currentMonth = currentMonth
        self.exampleViewController.setup(monthUpdatesDelegate: monthUpdatesDelegate, currentMonth: currentMonth)
    }
}
