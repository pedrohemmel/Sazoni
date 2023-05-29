//
//  CategoryViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    
    lazy var categoryView = CategoryView()
    
    override func loadView() {
        super.loadView()
        self.view = self.categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
