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
        shoppingListPublisher.subscribe(shoppingListSubscriper)
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            self.shoppingListsView.shoppingListsTableView.shoppingLists = ShoppingListManager.shared.shoppingLists
        }
        self.shoppingListsView.boughtListViewDelegate = self
        self.shoppingListsView.shoppingListsTableView.boughtListViewDelegate = self
    }
}

extension ShoppingListsViewController: BoughtListViewDelegate {
    func didClickCreateNew() {
        let newVC = ShoppingListCreateViewController(currentShoppingList: nil)
        self.present(newVC, animated: true)
    }
    func didClickEditList(currentShoppingList: ShoppingListModel) {
        let newVC = ShoppingListCreateViewController(currentShoppingList: currentShoppingList)
        self.present(newVC, animated: true)
    }
}

