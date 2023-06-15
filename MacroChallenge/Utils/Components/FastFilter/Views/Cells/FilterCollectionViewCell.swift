//
//  FilterCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    var filterImage: UIImageView = {
        let filterImage = UIImageView()
        filterImage.contentMode = .scaleAspectFit
        filterImage.translatesAutoresizingMaskIntoConstraints = false
        return filterImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.filterImage].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.filterImage.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.heightAnchor.constraint(equalToConstant: 50)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
            
    }
}
