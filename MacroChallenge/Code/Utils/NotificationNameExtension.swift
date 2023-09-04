//
//  NotificationNameExtension.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/09/23.
//

import UIKit

extension Notification.Name {
    static let favoriteCollectionFoods = Notification.Name("favoriteCollectionFoods")
}

let favoriteCollectionFoodsPublisher = NotificationCenter.Publisher(center: .default, name: .favoriteCollectionFoods)
    .map { (notification) -> [Food] in
        return (notification.object as? FoodCollectionView)?.foods ?? [Food]()
    }
