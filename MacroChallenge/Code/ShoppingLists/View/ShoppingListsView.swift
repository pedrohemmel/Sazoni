//
//  ShoppingListsView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit

class ShoppingListsView: UIView {
    
    weak var boughtListViewDelegate: BoughtListViewDelegate? = nil
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Listas"
        view.font = UIFont(name: "Quicksand-SemiBold", size: 64)
        view.textColor = UIColor(named: "darkBrown")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var shoppingListsTableView: ShoppingListsTableView = {
        let shoppingListsTableView = ShoppingListsTableView()
        shoppingListsTableView.backgroundColor = .clear
        shoppingListsTableView.backgroundView = .none
        shoppingListsTableView.separatorColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        shoppingListsTableView.translatesAutoresizingMaskIntoConstraints = false
        return shoppingListsTableView
    }()
    
    var buttonCreateNewShoppingList: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(red: 1, green: 0.98, blue: 0.867, alpha: 1)
        button.backgroundColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        button.addTarget(ShoppingListsView.self, action: #selector(buttonCreateAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListsView: ViewCode {
    func buildViewHierarchy() {
        [self.title, self.shoppingListsTableView, self.buttonCreateNewShoppingList].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -5.5),
                view.bottomAnchor.constraint(equalTo: self.shoppingListsTableView.topAnchor)

            ]
        }
        
        self.shoppingListsTableView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
        
        self.buttonCreateNewShoppingList.setupConstraints { view in
            [
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.widthAnchor.constraint(equalToConstant: 50),
                view.heightAnchor.constraint(equalToConstant: 50)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.buttonCreateNewShoppingList.layer.cornerRadius = 25
        self.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.867, alpha: 1)
    }
}

//MARK: - Functions here
extension ShoppingListsView {
    @objc func buttonCreateAction() {
        self.boughtListViewDelegate?.didClickCreateNew()
    }
}