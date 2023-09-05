//
//  NotificationNameExtension.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/09/23.
//

import UIKit

extension Notification.Name {
    static let favoriteCollectionFoods = Notification.Name("favoriteCollectionFoods")
    static let shoppingList = Notification.Name("shoppingList")
}

let favoriteCollectionFoodsPublisher = NotificationCenter.Publisher(center: .default, name: .favoriteCollectionFoods)
    .map { (notification) -> [Food] in
        return (notification.object as? FoodCollectionView)?.foods ?? [Food]()
    }

let shoppingListPublisher = NotificationCenter.Publisher(center: .default, name: .shoppingList)
    .map { (notification) -> [ShoppingListModel] in
        return (notification.object as? ShoppingListsTableView)?.shoppingLists ?? [ShoppingListModel]()
    }
