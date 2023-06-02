

import UIKit


class FoodCollectionView: UICollectionView{
    var foods = [Food]()
}


extension FoodCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        backgroundColor = .clear
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.foodImage.image = UIImage(named: foods[indexPath.row].image_source_food)
        cell.nameFood.text = foods[indexPath.row].name_food
        cell.sazonality.text = foods[indexPath.row].seasonalities[5].state_seasonality + " disponibilidade"
        
        cell.container.backgroundColor = UIColor(named: foods[indexPath.row]
            .seasonalities[5]
            .state_seasonality)
        cell.layer.cornerRadius = 20
        cell.container.layer.borderColor = UIColor(named: "Border"+foods[indexPath.row]
            .seasonalities[5]
            .state_seasonality)?.cgColor
        
        return cell
    }
}

extension FoodCollectionView:  UICollectionViewDelegate{
    
}
