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
        self.backgroundColor = UIColor.white
        self.backgroundView = UIView(frame: CGRect.zero)
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
        cell.sazonality.text = foods[indexPath.row].seasonalities[2].state_seasonality + " disponibilidade"
        
        cell.container.backgroundColor = UIColor(named: foods[indexPath.row]
            .seasonalities[foods[indexPath.row].seasonalities.firstIndex(where: {$0.month_name_seasonality == self.currentMonth}) ?? 0]
                                                           .state_seasonality)
        cell.layer.cornerRadius = 20
        cell.container.layer.borderColor = UIColor(named: "Border"+foods[indexPath.row].seasonalities[foods[indexPath.row].seasonalities.firstIndex(where: {$0.month_name_seasonality == self.currentMonth}) ?? 0].state_seasonality)?.cgColor
        
        return cell
    }
}

extension FoodCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        self.foodDelegate?.selectFood()
    }
}

//MARK: - Functions here
extension FoodCollectionView {
    func setup(foods: [Food], currentMonth: String) {
        self.foods = foods
        self.currentMonth = currentMonth
        self.reloadData()
    }
}
