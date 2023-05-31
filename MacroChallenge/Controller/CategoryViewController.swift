//
//  CategoryViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    //MARK: - Views
    lazy var categoryView = CategoryView(frame: self.view.frame)
    
    override func loadView() {
        super.loadView()
        self.view = self.categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
