//
//  CategoryCollectionViewComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewComponent: UICollectionView {
    
    weak var selectedCategoryDelegate: MCSelectedCategoryDelegate? = nil
    
    private var categories: [Category] = [Category]()
    
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
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryFood.text = self.categories[indexPath.row].name_category
        cell.categoryFood.textColor = .brown
        cell.categoryImage.image = UIImage(named: "icon_\(self.categories[indexPath.row].id_category)")
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.brown.cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 20
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension CategoryCollectionViewComponent: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryDelegate?.didSelectCategory(category: self.categories[indexPath.row])
    }
}

//MARK: - Functions
extension CategoryCollectionViewComponent {
    func setup(selectedCategoryDelegate: MCSelectedCategoryDelegate, categories: [Category]) {
        self.categories = categories
        self.selectedCategoryDelegate = selectedCategoryDelegate
        self.reloadData()
    }
}

