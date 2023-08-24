//
//  ShoppingListsTableViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 14/07/23.
//

import UIKit

class ShoppingListsTableViewCell: UITableViewCell {
    
    var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListsTableViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.title].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundView = .none
        self.backgroundColor = .clear
    }
}
