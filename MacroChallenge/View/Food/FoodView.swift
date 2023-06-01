//
//  FoodView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodView: UIView {
    
    private var foods = [Food]()
    
    private var capsule: UIImageView = {
        let capsule = UIImageView(image: UIImage(systemName: "chevron.compact.up", withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
        capsule.translatesAutoresizingMaskIntoConstraints = false
        return capsule
    }()
    
    private lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (self.bounds.width / 3) - 20, height: 180)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20

        let collectionViewInstance = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionViewInstance
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FoodView: ViewCode {
    func buildViewHierarchy() {
        [self.collectionView, self.capsule].forEach({self.addSubview($0)})
    }

    func setupConstraints() {
        self.capsule.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -20)
            ]
        }
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.capsule.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }

    func setupAdditionalConfiguration() {
        self.backgroundColor = .blue
    }
}

extension FoodView {
    func setup(foods: [Food]) {
        self.foods = foods
        self.collectionView.setup(foods: foods)
    }
}
