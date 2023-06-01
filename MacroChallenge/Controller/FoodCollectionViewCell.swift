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
//        view.layer.borderColor = .init(red: 0, green: 1, blue: 0, alpha: 0.5)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var foodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.nameFood.text = ""
//    }
}


extension FoodCollectionViewCell: ViewCode{
    func buildViewHierarchy() {
        contentView.addSubview(container)
        container.addSubview(nameFood)
        container.addSubview(sazonality)
        container.addSubview(foodImage)
    }
    
    func setupConstraints() {
        
        self.container.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: view.topAnchor),
                view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.widthAnchor.constraint(equalToConstant: 100),
                view.heightAnchor.constraint(equalToConstant: 132)
            ]}
        self.foodImage.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
        
        self.nameFood.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
//                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: sazonality.topAnchor)
            ]}
        
        self.sazonality.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: nameFood.bottomAnchor, constant: -30),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ]
        }

    }
    
    func setupAdditionalConfiguration() {
        /// Aqui estou declarando que o meu container tem como prioridade, sendo assim as demais view que estarão dentro dela irá se adequar ao seu tamanho.
        container.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
}
