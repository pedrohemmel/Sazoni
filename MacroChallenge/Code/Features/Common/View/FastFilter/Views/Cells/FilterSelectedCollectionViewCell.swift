//
//  FilterSelectedCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 09/06/23.
//

import UIKit

class FilterSelectedCollectionViewCell: UICollectionViewCell {
    //MARK: - Views
    var lblFilterSelected: UILabel = {
        let lblFilterSelected = UILabel()
        lblFilterSelected.textColor = .brown
        lblFilterSelected.translatesAutoresizingMaskIntoConstraints = false
        return lblFilterSelected
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterSelectedCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.lblFilterSelected].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.lblFilterSelected.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
}
