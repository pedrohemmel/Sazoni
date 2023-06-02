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
        monthBtn.setTitleColor(.black, for: .normal)
        monthBtn.titleLabel?.font =  UIFont.systemFont(ofSize: 30, weight: .heavy)
        monthBtn.layer.borderColor = UIColor.black.cgColor
        monthBtn.layer.borderWidth = 5
        monthBtn.layer.cornerRadius = 20
        monthBtn.translatesAutoresizingMaskIntoConstraints = false
        return monthBtn
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
        [self.monthBtn, self.categoryCollectionViewComponent].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.monthBtn.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: (self.bounds.height * 0.05)),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: self.categoryCollectionViewComponent.topAnchor, constant: -20),
                view.heightAnchor.constraint(equalToConstant: 150)
            ]
        }
        self.categoryCollectionViewComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.monthBtn.bottomAnchor, constant: 20),
                view.widthAnchor.constraint(equalToConstant: self.bounds.width),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}

//MARK: - Functions here
extension CategoryView {
    func setup(currentMonth: String) {
        self.currentMonth = currentMonth
        self.monthBtn.setTitle("\(currentMonth)", for: .normal)
    }
}
