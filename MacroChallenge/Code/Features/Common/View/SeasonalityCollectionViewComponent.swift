//
//  SeasonalityUICollectionView.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 13/06/23.
//

import UIKit

class SeasonalityUICollectionView: UICollectionView {

    var food: Food? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SeasonalityUICollectionView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return food?.seasonalities.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonalityCollectionViewCell", for: indexPath) as! SeasonalityCollectionViewCell
        cell.month.text = food?.seasonalities[indexPath.row].month_name_seasonality
        cell.availability.text = food?.seasonalities[indexPath.row].state_seasonality
        cell.availability.textColor = UIColor(named: "Border"+(food?.seasonalities[indexPath.row].state_seasonality ?? "Muito baixa"))
        return cell
    }
}

extension SeasonalityUICollectionView: ViewCode{
    func buildViewHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {
        self.register(SeasonalityCollectionViewCell.self, forCellWithReuseIdentifier: "SeasonalityCollectionViewCell")
        self.dataSource = self
        self.backgroundColor = .clear
        self.backgroundView = UIView(frame: CGRect.zero)
    }

}
