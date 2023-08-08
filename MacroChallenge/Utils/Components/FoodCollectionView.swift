//
//  FoodCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit
 

class FoodCollectionView: UICollectionView {
    var foods = [Food]() 
    weak var foodDelegate: FoodDetailDelegate? = nil
    weak var favoriteFoodDelegate: FavoriteFoodDelegate? = nil
    var currentMonth = ""
    
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
        self.backgroundView = .none
        self.backgroundColor = .clear
    }
}

extension FoodCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.foodImage.image = UIImage(named: "\(self.foods[indexPath.row].image_source_food)")
        cell.nameFood.text = foods[indexPath.row].name_food
        
        let currentStateSeasonality = self.foods[indexPath.row].seasonalities[self.foods[indexPath.row].seasonalities.firstIndex(where: { $0.month_name_seasonality == self.currentMonth }) ?? 0].state_seasonality
        cell.sazonality.text = currentStateSeasonality
        cell.sazonality.backgroundColor = UIColor(named: "\(currentStateSeasonality)")
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.brown.cgColor
        
        return cell
    }
}

extension FoodCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let foodDelegate = self.foodDelegate {
            foodDelegate.selectFood(food: foods[indexPath.row])
        }
        
        if let favoriteFoodDelegate = self.favoriteFoodDelegate {
            favoriteFoodDelegate.didSelectFood(food: foods[indexPath.row])
        }
    }
}

//MARK: - Functions here
extension FoodCollectionView {
    func setup(foods: [Food], currentMonth: String, foodDelegate: FoodDetailDelegate?, favoriteFoodDelegate: FavoriteFoodDelegate?) {
        self.foods = foods
        self.currentMonth = currentMonth
        self.favoriteFoodDelegate = favoriteFoodDelegate
        if let newFoodDelegate = foodDelegate {
            self.foodDelegate = newFoodDelegate
        }
        self.reloadData()
    }
    
}
