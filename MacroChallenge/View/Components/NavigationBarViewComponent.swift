//
//  NavigationBarViewComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 30/05/23.
//

import UIKit

class NavigationBarViewComponent: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Functions
extension NavigationBarViewComponent {
    func setupItems(title: String?, trailingButtonTitle: String?, leadingButtonTitle: String?) {
        var navItem = UINavigationItem()
        if let title = title {
            navItem = UINavigationItem(title: "\(title)")
        }
        
        if let trailingButtonTitle = trailingButtonTitle {
            let trailingItem = UIBarButtonItem(title: trailingButtonTitle, image: nil, target: nil, action: #selector(self.trailingButtonAction))
            navItem.rightBarButtonItem = trailingItem
        }
        
        if let leadingButtonTitle = leadingButtonTitle {
            let leadingItem = UIBarButtonItem(title: leadingButtonTitle, image: nil, target: nil, action: #selector(self.leadingButtonAction))
            navItem.leftBarButtonItem = leadingItem
        }
        
        self.setItems([navItem], animated: true)
    }
    
    @objc func trailingButtonAction() {
        
    }
    
    @objc func leadingButtonAction() {
        
    }
}


