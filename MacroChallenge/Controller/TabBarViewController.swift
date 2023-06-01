//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
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
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.setupTabItems()
    }
}

//MARK: - Functions here
extension TabBarViewController {
    private func setupTabItems() {
        let categoryViewController = UINavigationController(rootViewController: CategoryViewController())
        let exampleViewController = UINavigationController(rootViewController: FoodViewController())
        let exampleSecondaryViewController = UINavigationController(rootViewController: ExampleSecondaryViewController())
        
        self.setViewControllers([categoryViewController, exampleViewController, exampleSecondaryViewController], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "function")
        items[2].image = UIImage(systemName: "person.circle")
    }
}

