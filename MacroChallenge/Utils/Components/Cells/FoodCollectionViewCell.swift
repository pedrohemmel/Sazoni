//
//  FoodCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 31/05/23.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    //MARK: - Views
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 3
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var foodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nameFood: UILabel = {
        let nameFood = UILabel()
        nameFood.textColor = .black
        nameFood.translatesAutoresizingMaskIntoConstraints = false
        nameFood.textAlignment = .center
        nameFood.numberOfLines = 3
        nameFood.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return nameFood
    }()
    
    lazy var sazonality: UILabel = {
        let sazonality = UILabel()
        sazonality.textColor = .black
        sazonality.translatesAutoresizingMaskIntoConstraints = false
        sazonality.textAlignment = .center
        sazonality.numberOfLines = 2
        sazonality.font = UIFont.systemFont(ofSize: 11, weight: .regular)
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
        [self.container, self.foodImage, self.nameFood, self.sazonality].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.container.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
        
        self.foodImage.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.heightAnchor.constraint(equalToConstant: self.frame.width / 1.5),
                view.heightAnchor.constraint(equalToConstant: self.frame.width / 1.5),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        }
        
        self.nameFood.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.foodImage.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.sazonality.topAnchor, constant: -20)
            ]
        }
        
        self.sazonality.setupConstraints { view in
            [
                view.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -10),
                view.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 5),
                view.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -5)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
    }
    
}
