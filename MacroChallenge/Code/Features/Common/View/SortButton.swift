//
//  SortButton.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 10/09/23.
//

import UIKit

class SortButton: UIButton{
    
    weak var sortingDelegate: ShoppingListsSortingDelegate?
    private let manager = ShoppingListManager.shared
    
    private func menuButton() -> UIMenu{
        var menuItens: [UIMenuElement] {
            return [
                UIAction(title: "Alfabética Crescente", handler: { _ in
                    self.manager.orderShoppingLists(by: .growingAlphabetical)
                    self.sortingDelegate?.didChangeSortingOrder()

                }),
                UIAction(title: "Alfabética Decrescente", handler: { _ in
                    self.manager.orderShoppingLists(by: .decreasingAlphabetical)
                    self.sortingDelegate?.didChangeSortingOrder()

                }),
                UIAction(title: "Data Crescente",  handler: { _ in
                    self.manager.orderShoppingLists(by: .crescentDate)
                    self.sortingDelegate?.didChangeSortingOrder()

                }),
                UIAction(title: "Data Decrescente",  handler: { _ in
                    self.manager.orderShoppingLists(by: .decreasingDate)
                    self.sortingDelegate?.didChangeSortingOrder()

                })
            ]
        }
        return UIMenu(title: "",options: .displayInline,children: menuItens)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.menu = menuButton()
        self.showsMenuAsPrimaryAction = true
        self.layer.cornerRadius = 4
        self.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        self.tintColor = .SZColorBeige
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.SZColorBeige?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
