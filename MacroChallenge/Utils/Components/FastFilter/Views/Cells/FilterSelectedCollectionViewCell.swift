//
//  FilterSelectedCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 09/06/23.
//

import UIKit

class FilterSelectedCollectionViewCell: UICollectionViewCell {
    
    var lblFilterSelected: UILabel = {
        let lblFilterSelected = UILabel()
        lblFilterSelected.textColor = .brown
        lblFilterSelected.translatesAutoresizingMaskIntoConstraints = false
        return lblFilterSelected
    }()
    var btnDeleteFilterSelected: UIButton = {
        let btnDeleteFilterSelected = UIButton()
        btnDeleteFilterSelected.setImage(UIImage(systemName: "xmark"), for: .normal)
        btnDeleteFilterSelected.tintColor = .brown
        btnDeleteFilterSelected.translatesAutoresizingMaskIntoConstraints = false
        return btnDeleteFilterSelected
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
        [self.lblFilterSelected, self.btnDeleteFilterSelected].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.lblFilterSelected.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                view.trailingAnchor.constraint(equalTo: self.btnDeleteFilterSelected.leadingAnchor, constant: -10)
            ]
        }
        
        self.btnDeleteFilterSelected.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                view.leadingAnchor.constraint(equalTo: self.lblFilterSelected.trailingAnchor, constant: 10)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
}
