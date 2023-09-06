//
//  ShoppingListCreateViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 17/07/23.
//

import UIKit

protocol ShoppingListCreateDelegate: AnyObject {
    func didClickConfirm()
}

class ShoppingListCreateViewController: UIViewController {
    private var shoppingListCreateView = ShoppingListCreateView()
    
    init(currentShoppingList: ShoppingListModel?) {
        self.shoppingListCreateView.currentShoppingList = currentShoppingList
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = shoppingListCreateView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListCreateView.delegate = self
    }
}

extension ShoppingListCreateViewController: ShoppingListCreateDelegate {
    func didClickConfirm() {
        self.dismiss(animated: true)
    }
}
