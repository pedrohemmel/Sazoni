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
//        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameFood: UILabel = {
        let nameFood = UILabel()
        nameFood.textColor = .black
        nameFood.textAlignment = .left
        nameFood.numberOfLines = 2
        nameFood.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameFood.translatesAutoresizingMaskIntoConstraints = false
        return nameFood
    }()
    
    lazy var sazonality: UILabel = {
        let sazonality = UILabel()
        sazonality.textColor = .black
        sazonality.textAlignment = .center
        sazonality.numberOfLines = 2
        sazonality.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        sazonality.layer.cornerRadius = 11/2
        sazonality.clipsToBounds = true
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
        self.nameFood.text = ""
        self.sazonality.text = ""
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
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.widthAnchor.constraint(equalToConstant: self.frame.width / 2)
            ]
        }
        
        self.foodImage.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.heightAnchor.constraint(equalToConstant: self.frame.width),
                view.widthAnchor.constraint(equalToConstant: self.frame.width),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            ]
        }
        
        self.nameFood.setupConstraints { view in
            [
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ]
        }
        
        
    }
    
    func setupAdditionalConfiguration() {
        self.clipsToBounds = true
        
    }
    
}
