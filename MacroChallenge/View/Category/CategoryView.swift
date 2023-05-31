//
//  CategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryView: UIView {
    //MARK: - Views
    lazy var categoryTitle: UILabel = {
        let title = UILabel()
        title.text = "Categorias"
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var monthBtn: UIButton = {
        let monthBtn = UIButton()
        monthBtn.setTitle("Mês", for: .normal)
        monthBtn.backgroundColor = .gray
        monthBtn.layer.cornerRadius = 10
        monthBtn.translatesAutoresizingMaskIntoConstraints = false
        return monthBtn
    }()
    
    lazy var categoryCollectionViewComponent = {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let spaceBetweenItems = 40.0
        collectionViewLayout.itemSize = CGSize(width: (self.bounds.width / 2 - spaceBetweenItems), height: (self.bounds.width / 2 - spaceBetweenItems))
        collectionViewLayout.minimumInteritemSpacing = 20
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.scrollDirection = .vertical
        
        let categoryCollectionViewComponent = CategoryCollectionViewComponent(frame: .zero, collectionViewLayout: collectionViewLayout)
        categoryCollectionViewComponent.translatesAutoresizingMaskIntoConstraints = false
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
        [self.categoryTitle, self.monthBtn, self.categoryCollectionViewComponent].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.categoryTitle.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.monthBtn.topAnchor, constant: -(self.bounds.height * 0.05))
            ]
        }
        self.monthBtn.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.categoryTitle.bottomAnchor, constant: (self.bounds.height * 0.05)),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                view.bottomAnchor.constraint(equalTo: self.categoryCollectionViewComponent.topAnchor, constant: -20),
                view.heightAnchor.constraint(equalToConstant: 150)
            ]
        }
        self.categoryCollectionViewComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.monthBtn.bottomAnchor, constant: 20),
                view.widthAnchor.constraint(equalToConstant: self.bounds.width),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .systemGray5
    }
}
