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
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor(named: "Background")?.cgColor
        self.searchBarStyle = UISearchBar.Style.minimal
        
        self.searchTextField.layer.cornerRadius = 10
        self.searchTextField.layer.borderWidth = 3
        self.searchTextField.layer.borderColor = UIColor.brown.cgColor
        
        self.searchTextField.tintColor = .brown
        self.searchTextField.textColor = .brown
        self.searchTextField.leftView?.tintColor = .brown
        
        self.searchTextField.background = .none
        self.searchTextField.backgroundColor = .white
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
