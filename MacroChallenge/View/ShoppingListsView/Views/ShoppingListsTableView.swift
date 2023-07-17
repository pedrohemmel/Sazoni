//
//  ShoppingListsTableView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit

class ShoppingListsTableView: UITableView {
    
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
    }
}
