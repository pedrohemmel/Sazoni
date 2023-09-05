//
//  FoodCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit
 

class FoodCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout{
    weak var foodDelegate: FoodDetailDelegate? = nil
    weak var favoriteFoodDelegate: FavoriteFoodDelegate? = nil
    var foods = [Food]() {
        didSet {
            reloadData()
        }
    }
    var currentMonth = String()
    private let spacing:CGFloat = 16.0

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        self.backgroundView = .none
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FoodCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        let currentStateSeasonality = self.foods[indexPath.row].seasonalities[self.foods[indexPath.row].seasonalities.firstIndex(where: { $0.month_name_seasonality == self.currentMonth }) ?? 0].state_seasonality
        cell.sazonality.image = UIImage.getImageSazonality(currentStateSeasonality)
        cell.foodImage.image = UIImage(named: "\(self.foods[indexPath.row].image_source_food)")
        cell.nameFood.text = foods[indexPath.row].name_food
        cell.backgroundColor = .SZColorBeige
        cell.layer.cornerRadius = .SZCornerRadiusMediumShape
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
    }
    
}
