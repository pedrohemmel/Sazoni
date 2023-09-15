//
//  FoodCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 31/05/23.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    //MARK: - Views
        
    lazy var foodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameFood: UILabel = {
        let nameFood = UILabel()
        nameFood.font = .SZFontText
        nameFood.textColor = .SZColorDarkGrey
        nameFood.numberOfLines = 2
        nameFood.textAlignment = .center
        nameFood.translatesAutoresizingMaskIntoConstraints = false
        return nameFood
    }()
    
    lazy var sazonality: UIImageView = {
        let sazonality = UIImageView()
        sazonality.translatesAutoresizingMaskIntoConstraints = false
        return sazonality
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
        self.foodImage.image = nil
        self.nameFood.text = String()
    }
}


extension FoodCollectionViewCell: ViewCode{
    func buildViewHierarchy() {
        [self.foodImage, self.sazonality, self.nameFood].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        
        self.sazonality.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            ]
        }
        
        self.foodImage.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.heightAnchor.constraint(equalToConstant: 90),
                view.widthAnchor.constraint(equalToConstant: 90),
                view.bottomAnchor.constraint(equalTo: self.nameFood.topAnchor, constant: 16)
            ]
        }
        
        self.nameFood.setupConstraints { view in
            [
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ]
        }
        
        
        
    }
    
    func setupAdditionalConfiguration() {
        self.clipsToBounds = true
    }
    
}
