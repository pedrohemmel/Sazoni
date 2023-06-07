//
//  FilterSelectedCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterSelectedCollectionView: UICollectionView {
    weak var openSheetDelegate: OpenSheetDelegate? = nil
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(openSheetDelegate: OpenSheetDelegate) {
        self.openSheetDelegate = openSheetDelegate
    }
}

//MARK: - DataSource
extension FilterSelectedCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 10
        return cell
    }
    
}

//MARK: - Delegate
extension FilterSelectedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openSheetDelegate?.didClickCell()
    }
}

