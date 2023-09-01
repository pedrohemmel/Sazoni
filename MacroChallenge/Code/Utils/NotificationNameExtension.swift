//
//  NotificationNameExtension.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 31/08/23.
//

import UIKit
import Combine

extension Notification.Name {
    static let foodEvent = Notification.Name("food_event")
}

let foodEventPublisher = NotificationCenter.Publisher(center: .default, name: .foodEvent)
    .map { (notification) -> [Food]? in
        return (notification.object as? FoodEvent)?.foods ?? [Food]()
    }
