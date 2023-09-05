//
//  ShoppingListCreateView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 17/07/23.
//

import UIKit

class ShoppingListCreateView: UIView {
    
    weak var delegate: ShoppingListCreateDelegate? = nil
    var currentShoppingList: ShoppingListModel?
    
    private var title: UILabel = {
        let view = UILabel()
        view.text = "Crie uma nova lista"
        view.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        view.textColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var txtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Digite aqui"
        txtField.layer.cornerRadius = 10
        txtField.layer.borderWidth = 3
        txtField.layer.borderColor = UIColor.brown.cgColor
        txtField.tintColor = .brown
        txtField.textColor = .brown
        txtField.leftView?.tintColor = .brown
        txtField.background = .none
        txtField.backgroundColor = .white
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    lazy var confirmBtn: UIButton = {
        let createBtn = UIButton()
        createBtn.backgroundColor = .blue
        createBtn.layer.cornerRadius = 15
        createBtn.setTitle("Confirmar", for: .normal)
        createBtn.addTarget(self, action: #selector(confirmShoppingList), for: .touchUpInside)
        createBtn.translatesAutoresizingMaskIntoConstraints = false
        return createBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListCreateView: ViewCode {
    func buildViewHierarchy() {
        [self.title, self.txtField, self.confirmBtn].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -5.5),
                view.bottomAnchor.constraint(equalTo: self.txtField.topAnchor)
            ]
        }
        
        self.txtField.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.confirmBtn.topAnchor, constant: -30),
                view.heightAnchor.constraint(equalToConstant: 30)
            ]
        }
        self.confirmBtn.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.txtField.bottomAnchor, constant: 30),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.heightAnchor.constraint(equalToConstant: 50),
                view.widthAnchor.constraint(equalToConstant: self.confirmBtn.intrinsicContentSize.width + 30)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.867, alpha: 1)
    }
}


extension ShoppingListCreateView {
    @objc func confirmShoppingList() {
        if let currentShoppingList {
            if self.txtField.text == ""{
                ShoppingListManager.shared.changeBoughtListName(ShoppingListManager.shared.defaultKey, idBoughtList: currentShoppingList.id, newName: nil)
            } else {
                ShoppingListManager.shared.changeBoughtListName(ShoppingListManager.shared.defaultKey, idBoughtList: currentShoppingList.id, newName: self.txtField.text)
            }
        } else {
            if self.txtField.text == ""{
                ShoppingListManager.shared.createNewBoughtList(ShoppingListManager.shared.defaultKey, name: nil)
            } else {
                ShoppingListManager.shared.createNewBoughtList(ShoppingListManager.shared.defaultKey, name: self.txtField.text)
            }
        }
        
        let shoppingListsTableView = ShoppingListsTableView(frame: .zero, style: .grouped)
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            shoppingListsTableView.shoppingLists = ShoppingListManager.shared.shoppingLists
            NotificationCenter.default.post(name: .shoppingList, object: shoppingListsTableView)
        }
        delegate?.didClickConfirm()
    }
}
