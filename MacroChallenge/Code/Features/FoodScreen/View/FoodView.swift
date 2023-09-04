//
//  FoodView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodView: UIView {
    
    private var currentMonth: String? = nil
    private var foods = [Food]()
    var category = Category(id_category: .zero, name_category: String())
    
    //MARK: - Views
    private lazy var monthTitle: UILabel = {
        let monthTitle = UILabel()
        monthTitle.text = self.currentMonth
        monthTitle.font = .SZFontTitle
        monthTitle.textColor = .SZColorBeige
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        return monthTitle
    }()
    
    lazy var search: SearchBarComponent = {
        let view = SearchBarComponent()
        view.searchTextField.attributedPlaceholder = NSAttributedString(string: "Buscar", attributes: [NSAttributedString.Key.foregroundColor: UIColor.SZColorBeige ?? .white])
        view.searchTextField.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fastFilterComponent: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    
    var fastFilterMonth: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.backgroundColor = .clear
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    
    
    lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .SZSizeCellFood
        layout.minimumInteritemSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 32, left: 8, bottom: 32, right: 8)
        let collectionViewInstance = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionViewInstance
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FoodView: ViewCode {
    func buildViewHierarchy() {
        [self.monthTitle, self.search, self.fastFilterComponent, self.fastFilterMonth, self.collectionView].forEach({self.addSubview($0)})
    }

    func setupConstraints() {
        self.monthTitle.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.search.topAnchor)
            ]
        }
        
        self.search.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.monthTitle.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.fastFilterComponent.topAnchor)
            ]
        }
        
        self.fastFilterMonth.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.monthTitle.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.search.trailingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.fastFilterComponent.topAnchor)
            ]
        }
        
        self.fastFilterComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.search.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.midX * 0.4),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.midX * 0.4),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor),
            ]
        }
        
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.fastFilterComponent.bottomAnchor),
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

//MARK: - Functions here
extension FoodView {
    func setup(foods: [Food], currentMonth: String, category: Category, foodDelegate: FoodDetailDelegate?) {
        self.currentMonth = currentMonth
        self.category = category
        
        self.collectionView.setup(foods: foods, currentMonth: currentMonth, foodDelegate: foodDelegate, favoriteFoodDelegate: nil)
        self.monthTitle.text = currentMonth
        
        self.setupViewConfiguration()
    }
}
