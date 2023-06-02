//
//  CategoryCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    //MARK: - Views
    lazy var categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var categoryFood: UILabel = {
        let nameFood = UILabel()
        nameFood.textColor = .black
        nameFood.translatesAutoresizingMaskIntoConstraints = false
        nameFood.textAlignment = .center
        nameFood.numberOfLines = 3
        nameFood.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return nameFood
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
        self.categoryFood.text = ""
        self.categoryImage.image = nil
    }
}

//MARK: - ViewCode
extension CategoryCollectionViewCell: ViewCode {
    func buildViewHierarchy() {
        [self.categoryFood, self.categoryImage].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.categoryFood.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                view.bottomAnchor.constraint(equalTo: self.categoryImage.topAnchor, constant: -20)
            ]
        }
        
        self.categoryImage.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.categoryFood.bottomAnchor, constant: 20)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
    }
}
