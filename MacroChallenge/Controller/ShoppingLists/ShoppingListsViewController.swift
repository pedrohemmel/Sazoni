//
//  ShoppingListsViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit

class ShoppingListsViewController: UIViewController {
    
    weak var boughtListCRUDDelegate: BoughtListCRUDDelegate? = nil
    var shoppingListsView = ShoppingListsView()
    
    override func loadView() {
        super.loadView()
        self.view = shoppingListsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shoppingListsView.boughtListViewDelegate = self
    }
}

extension ShoppingListsViewController: BoughtListViewDelegate {
    func didClickCreateNew() {
        let newVC = ShoppingListCreateViewController()
        
        newVC.boughtListViewDelegate = self
        
        let backBtn = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(back))
        backBtn.tintColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        newVC.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func didCreateNew(name: String?) {
        self.boughtListCRUDDelegate?.createNewBoughtList("boughtList", name: name)
        if let boughtList = self.boughtListCRUDDelegate?.getAllBoughtList("boughtList") {
            self.shoppingListsView.shoppingListsTableView.shoppingLists = boughtList
        }
    }
}

//MARK: - Functions here
extension ShoppingListsViewController {
    func setup(boughtList: [ShoppingListModel]) {
        self.shoppingListsView.shoppingListsTableView.shoppingLists = boughtList
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
