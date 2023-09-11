//
//  ShoppingListCreateView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 17/07/23.
//

import UIKit

class ShoppingListCreateView: UIView {
    
    weak var delegate: ShoppingListCreateDelegate? = nil
    var currentShoppingList: ShoppingListModel? {
        didSet {
            if let currentShoppingList {
                if !(currentShoppingList.name == "Sem título") {
                    txtField.text = currentShoppingList.name
                }
            }
        }
    }
    
    private var capsule: UIImageView = {
        let capsule = UIImageView(image: UIImage(named: "menuItem"))
        capsule.translatesAutoresizingMaskIntoConstraints = false
        return capsule
    }()
    
    private var title: UILabel = {
        let view = UILabel()
        view.text = "Dê um nome para sua lista"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = .SZFontTitle
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var txtField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Digite aqui"
        txtField.textAlignment = .center
        txtField.textColor = .SZColorBeige
        txtField.font = UIFont.systemFont(ofSize: 25)
        txtField.attributedPlaceholder = NSAttributedString(
            string: "Digite aqui",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.SZColorBeige,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        )
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    var lineTxtField: UIView = {
        let view = UIView()
        view.backgroundColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let createBtn = UIButton()
        createBtn.setTitleColor(.SZColorSecundaryColor, for: .normal)
        createBtn.backgroundColor = .SZColorBeige
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
        [self.title, self.txtField, self.lineTxtField, self.confirmBtn, self.capsule].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.capsule.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.title.topAnchor, constant: -30)
            ]
        }
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.capsule.bottomAnchor, constant: 30),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.txtField.topAnchor, constant: -50)
            ]
        }
        
        self.txtField.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 50),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.lineTxtField.topAnchor, constant: -5),
                view.heightAnchor.constraint(equalToConstant: 30)
            ]
        }
        
        self.lineTxtField.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.txtField.bottomAnchor, constant: 5),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.lineTxtField.topAnchor, constant: -50),
                view.heightAnchor.constraint(equalToConstant: 2)
            ]
        }
        self.confirmBtn.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.lineTxtField.bottomAnchor, constant: 50),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.heightAnchor.constraint(equalToConstant: 50),
                view.widthAnchor.constraint(equalToConstant: self.confirmBtn.intrinsicContentSize.width + 30)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .SZColorPrimaryColor
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
            NotificationCenter.default.post(name: .shoppingLists, object: shoppingListsTableView)
        }
        delegate?.didClickConfirm()
    }
}
