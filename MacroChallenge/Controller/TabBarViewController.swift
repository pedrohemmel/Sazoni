//
//  TabBaraViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    private var foods = [Food]()
    private var dataIsReceived = false
    lazy private var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.setupViewConfiguration()
    })
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
    }
}

//MARK: - ViewCode
extension TabBarViewController: ViewCode {
    func buildViewHierarchy() {
    }
    
    func setupConstraints() {
    }
    
    func setupAdditionalConfiguration() {
        
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
        }
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.setupTabItems()
    }
}

//MARK: - Functions here
extension TabBarViewController {
    private func setupTabItems() {
        let exampleViewController = UINavigationController(rootViewController: ExampleViewController())
        let exampleSecondaryViewController = UINavigationController(rootViewController: ExampleSecondaryViewController())
        
        self.setViewControllers([exampleViewController, exampleSecondaryViewController], animated: true)
        
        guard let items = self.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "function")
        items[1].image = UIImage(systemName: "person.circle")
    }
}

