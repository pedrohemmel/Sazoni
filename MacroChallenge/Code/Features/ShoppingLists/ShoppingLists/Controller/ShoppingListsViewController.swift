//
//  ShoppingListsViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit
import Combine

protocol BoughtListViewDelegate: AnyObject {
    func didClickCreateNew()
    func didSelectList(shoppingList: ShoppingListModel)
    func didClickEditList(currentShoppingList: ShoppingListModel)
}

class ShoppingListsViewController: UIViewController {
    
    private var shoppingListsView = ShoppingListsView()
    
    private lazy var shoppingListSubscriper = Subscribers.Assign(object: shoppingListsView.shoppingListsTableView, keyPath: \.shoppingLists)
    
    override func loadView() {
        super.loadView()
        self.view = shoppingListsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListsPublisher.subscribe(shoppingListSubscriper)
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            self.shoppingListsView.shoppingListsTableView.shoppingLists = ShoppingListManager.shared.shoppingLists
        }
        self.shoppingListsView.boughtListViewDelegate = self
        self.shoppingListsView.shoppingListsTableView.boughtListViewDelegate = self
        self.shoppingListsView.search.searchDelegate = self
    }
}

extension ShoppingListsViewController: SearchDelegate {
    func search(with searchText: String) {
        ShoppingListManager.shared.searchShoppingLists(with: searchText)
        self.shoppingListsView.shoppingListsTableView.shoppingLists = ShoppingListManager.shared.filteredShoppingLists
    }
}

extension ShoppingListsViewController: BoughtListViewDelegate {
    func didClickCreateNew() {
        let newVC = ShoppingListCreateViewController(currentShoppingList: nil)
        self.present(newVC, animated: true)
    }
    
    func didSelectList(shoppingList: ShoppingListModel) {
        let newVC = ShoppingListController(shoppingList: shoppingList)
        
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.setTitle("Voltar", for: .normal)
        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        newVC.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func didClickEditList(currentShoppingList: ShoppingListModel) {
        let newVC = ShoppingListCreateViewController(currentShoppingList: currentShoppingList)
        self.present(newVC, animated: true)
    }
}

extension ShoppingListsViewController {
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

