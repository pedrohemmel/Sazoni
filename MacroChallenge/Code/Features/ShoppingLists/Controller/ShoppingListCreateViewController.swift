//
//  ShoppingListCreateViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 17/07/23.
//

import UIKit

class ShoppingListCreateViewController: UIViewController {
    
    weak var boughtListViewDelegate: BoughtListViewDelegate? = nil
    private var shoppingListCreateView = ShoppingListCreateView()
    
    override func loadView() {
        super.loadView()
        self.view = self.shoppingListCreateView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let addNewBtn = UIBarButtonItem(title: "Adicionar", style: .done, target: self, action: #selector(addNewShoppingList))
        addNewBtn.tintColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        self.navigationItem.rightBarButtonItem = addNewBtn
    }
}

extension ShoppingListCreateViewController {
    @objc func addNewShoppingList() {
        self.boughtListViewDelegate?.didCreateNew(name: self.shoppingListCreateView.txtField.text)
        self.navigationController?.popViewController(animated: true)
    }
}
