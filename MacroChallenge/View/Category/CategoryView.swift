//
//  CategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryView: UIView {
    
    //MARK: - Views
    lazy var categoryCollectionViewComponent = {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 8
        let categoryCollectionViewComponent = CategoryCollectionViewComponent(frame: .zero, collectionViewLayout: collectionViewLayout)
        return categoryCollectionViewComponent
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryView: ViewCode {
    func buildViewHierarchy() {
        [self.categoryCollectionViewComponent].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .purple
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
