//
//  FoodCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodCollectionView: UICollectionView {
    var foods = [Food]()
    
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
        self.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        self.delegate = self
        self.dataSource = self
    }
}

extension FoodCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.foodImage.image = UIImage(named: "laranja")
        cell.nameFood.text = foods[indexPath.row].name_food
        cell.sazonality.text = foods[indexPath.row].seasonalities[2].state_seasonality + " disponibilidade"
        
        cell.container.backgroundColor = UIColor(named: foods[indexPath.row]
                                                           .seasonalities[2]
                                                           .state_seasonality)
        cell.layer.cornerRadius = 20
        cell.container.layer.borderColor = UIColor(named: "Border"+foods[indexPath.row]
                                                                       .seasonalities[2]
                                                                       .state_seasonality)?.cgColor
        
        cell.backgroundColor = .cyan
        return cell
    }
}

extension FoodCollectionView: UICollectionViewDelegate {
    
}

//MARK: - Functions here
extension FoodCollectionView {
    func setup(foods: [Food]) {
        self.foods = foods
        self.reloadData()
    }
}
