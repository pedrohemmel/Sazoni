//
//  CategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryView: UIView {
    
    private var categories: [Category]
    
    //MARK: - Views
    private lazy var title: UILabel = {
        let text = UILabel()
        text.text = "Bem vindo ao Sazoni!"
        text.font = .SZFontTitle
        text.textColor = .SZColorBeige
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var subTitle: UILabel = {
        let text = UILabel()
        text.text = "Escolha uma categoria para \ncomeçar."
        text.font = .SZFontSubTitle
        text.textColor = .SZColorBeige
        text.textAlignment = .center
        text.numberOfLines = 2
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var categoryCollectionViewComponent = {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = .SZSizeLargeCell
        collectionViewLayout.minimumLineSpacing = 36
        collectionViewLayout.minimumInteritemSpacing = 26
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 64, left: 8, bottom: 32, right: 8)
        collectionViewLayout.scrollDirection = .vertical
        let categoryCollectionViewComponent = CategoryCollectionViewComponent(frame: .zero, collectionViewLayout: collectionViewLayout, categories: self.categories)
        categoryCollectionViewComponent.translatesAutoresizingMaskIntoConstraints = false
        return categoryCollectionViewComponent
    }()
    
    init(frame: CGRect, categories: [Category]) {
        self.categories = categories
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryView: ViewCode {
    func buildViewHierarchy() {
        [self.title,self.subTitle, self.categoryCollectionViewComponent].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: (self.bounds.height * 0.01)),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.subTitle.topAnchor, constant: -(self.bounds.height * 0.05))
            ]
        }
        
        self.subTitle.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: (self.bounds.height * 0.1)),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.categoryCollectionViewComponent.topAnchor)
            ]
        }
        
        self.categoryCollectionViewComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor, constant: (self.bounds.height * 0.1)),
                view.widthAnchor.constraint(equalToConstant: self.bounds.width),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
        
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .SZColorPrimaryColor
    }
}
