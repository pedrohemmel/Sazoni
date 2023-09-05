//
//  CategoryCollectionViewComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryCollectionViewComponent: UICollectionView {
    
    weak var selectedCategoryDelegate: MCSelectedCategoryDelegate?
    
    private var categories: [Category] = [Category]()
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, categories: [Category]) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.categories = categories
        self.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        cell.categoryFood.textColor = .SZColorSecundaryColor
        cell.categoryImage.image = UIImage.getImageCategory("icon_\(self.categories[indexPath.row].id_category)")
        cell.backgroundColor = .SZColorBeige
        cell.layer.cornerRadius = .SZCornerRadiusLargeShapes
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension CategoryCollectionViewComponent: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategoryDelegate?.didSelectCategory(category: self.categories[indexPath.row])
    }
}
