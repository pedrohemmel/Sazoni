//
//  ShoppingListsTableView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit

class ShoppingListsTableView: UITableView{
    
    weak var boughtListViewDelegate: BoughtListViewDelegate? = nil
    var shoppingLists = [ShoppingListModel]() {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(ShoppingListsTableViewCell.self, forCellReuseIdentifier: "ShoppingListsTableViewCell")
        self.dataSource = self
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShoppingListsTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListsTableViewCell") as! ShoppingListsTableViewCell
        cell.title.text = self.shoppingLists[indexPath.row].name ?? "Sem título"
        return cell
    }
    
}

extension ShoppingListsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: true)
        self.boughtListViewDelegate?.didSelectList(shoppingList: shoppingLists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .destructive, title: "Deletar") {  (contextualAction, view, boolValue) in
            self.presentDeletionFailsafe(indexPath: indexPath)
        }
        
        let editItem = UIContextualAction(style: .normal, title: "Editar") {  (contextualAction, view, boolValue) in
            self.boughtListViewDelegate?.didClickEditList(currentShoppingList: self.shoppingLists[indexPath.row])
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        return swipeActions
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Apagar a lista ”\(self.shoppingLists[indexPath.row].name!)”", message: "Isto apagará todos os itens da sua lista.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            ShoppingListManager.shared.deleteBoughtList(ShoppingListManager.shared.defaultKey, idBoughtList: self.shoppingLists[indexPath.row].id)
            ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
                self.shoppingLists = ShoppingListManager.shared.shoppingLists
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { _ in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        if let windowViewController = window?.rootViewController {
            windowViewController.present(alert, animated: true)
        }
        
    }
}
