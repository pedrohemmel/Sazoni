//
//  ShoppingListModel.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 10/07/23.
//

import Foundation

struct ShoppingListModel: Codable {
    let id: Int
    var itemShoppingListModel: [ItemShoppingListModel]
    var isClosed: Bool
}
