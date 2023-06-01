//
//  FoodCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension FoodCollectionView: ViewCode {
    func buildViewHierarchy() {
    }
    
    func setupConstraints() {
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor.white
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        self.delegate = self
        self.dataSource = self
    }
}

extension FoodCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension FoodCollectionView: UICollectionViewDelegate {
    
}
