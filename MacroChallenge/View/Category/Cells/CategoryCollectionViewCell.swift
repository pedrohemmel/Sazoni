//
//  CategoryCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    //MARK: - Views
    var title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = ""
    }
}

//MARK: - ViewCode
extension CategoryCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.title].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
    }
}
