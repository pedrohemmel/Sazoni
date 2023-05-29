//
//  CategoryCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = .blue
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
}

//MARK: - ViewCode
extension CategoryCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.title].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
