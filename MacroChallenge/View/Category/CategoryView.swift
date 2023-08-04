//
//  CategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import UIKit

class CategoryView: UIView {
    
    private var currentMonth: String? = nil
    
    //MARK: - Views
    lazy var monthTitle: UILabel = {
        let monthTitle = UILabel()
        monthTitle.text = self.currentMonth
        monthTitle.font = UIFont(name: "Quicksand-SemiBold", size: 64)
        monthTitle.textColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        return monthTitle
    }()
    
    lazy var categoryCollectionViewComponent = {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let spaceBetweenItems = 20.0
        collectionViewLayout.itemSize = CGSize(width: (self.bounds.width / 2 - spaceBetweenItems), height: (self.bounds.width / 2 - spaceBetweenItems))
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
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
        [self.monthTitle, self.categoryCollectionViewComponent].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.monthTitle.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: (self.bounds.height * 0.05)),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.categoryCollectionViewComponent.topAnchor, constant: -(self.bounds.height * 0.1))
            ]
        }
        self.categoryCollectionViewComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.monthTitle.bottomAnchor, constant: (self.bounds.height * 0.1)),
                view.widthAnchor.constraint(equalToConstant: self.bounds.width),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor(named: "Background")
    }
}

//MARK: - Functions here
extension CategoryView {
    func setup(currentMonth: String) {
        self.currentMonth = currentMonth
        self.monthTitle.text = currentMonth
    }
}
