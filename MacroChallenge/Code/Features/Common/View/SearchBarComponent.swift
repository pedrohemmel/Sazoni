//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 02/06/23.
//

import UIKit

class SearchBarComponent: UISearchBar {
        
    weak var searchViewController: SearchViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.searchBarStyle = UISearchBar.Style.minimal
        self.searchTextField.layer.cornerRadius = 4
        self.searchTextField.layer.borderWidth = 1
        self.searchTextField.layer.borderColor = UIColor.SZColorBeige?.cgColor
        self.searchTextField.leftView?.tintColor = .SZColorBeige
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchBarComponent: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewController?.filterFoods(with: searchText)
    }
}
