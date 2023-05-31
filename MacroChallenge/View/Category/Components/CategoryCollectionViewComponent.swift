//
//  CategoryCollectionViewComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewComponent: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ViewCode
extension CategoryCollectionViewComponent: ViewCode {
    func buildViewHierarchy() {
    }
    func setupConstraints() {
    }
    func setupAdditionalConfiguration() {
        self.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
    }
}

//MARK: - UICollectionViewDataSource
extension CategoryCollectionViewComponent: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.title.text = "Ola\(indexPath.row)"
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 10
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension CategoryCollectionViewComponent: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicou")
    }
}

