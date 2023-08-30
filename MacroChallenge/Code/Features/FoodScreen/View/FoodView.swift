//
//  FoodView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodView: UIView {
    
    weak var categorySwipeDelegate: MCCategorySwipeDelegate? = nil
    weak var monthButtonDelegate: MCMonthNavigationButtonDelegate? = nil
    private var currentMonth: String? = nil
    private var foods = [Food]()
    private var category = Category(id_category: 0, name_category: "")
    
    //MARK: - Views
    private lazy var monthTitle: UILabel = {
        let monthTitle = UILabel()
        monthTitle.text = self.currentMonth
        monthTitle.font = UIFont(name: "Quicksand-SemiBold", size: 64)
        monthTitle.textColor = UIColor(named: "darkBrown")
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        return monthTitle
    }()
    
    private lazy var foodCategoryName: UILabel = {
        let foodCategoryName = UILabel()
        foodCategoryName.text = self.category.name_category
        foodCategoryName.font = UIFont(name: "Quicksand-Medium", size: 34)
        foodCategoryName.textColor = UIColor(named: "darkBrown")
        foodCategoryName.translatesAutoresizingMaskIntoConstraints = false
        return  foodCategoryName
    }()
    private lazy var chevronLeftButton: UIButton = {
        let chevronLeftButton = UIButton()
        chevronLeftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        chevronLeftButton.tintColor = UIColor(named: "darkBrown")
        chevronLeftButton.addTarget(self, action: #selector(self.chevronLeftAction), for: .touchUpInside)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronLeftButton
    }()
    private lazy var chevronRightButton: UIButton = {
        let chevronRightButton = UIButton()
        chevronRightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronRightButton.tintColor = UIColor(named: "darkBrown")
        chevronRightButton.addTarget(self, action: #selector(self.chevronRightAction), for: .touchUpInside)
        chevronRightButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronRightButton
    }()
    
    private lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 105, height: 140)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
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
        [self.monthTitle, self.foodCategoryName, self.chevronLeftButton, self.chevronRightButton, self.collectionView].forEach({self.addSubview($0)})
    }

    func setupConstraints() {
        self.monthTitle.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.foodCategoryName.topAnchor)
            ]
        }
        
        self.foodCategoryName.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.monthTitle.bottomAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -30)
            ]
        }
        
        self.chevronLeftButton.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.foodCategoryName.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  self.frame.width * 0.25),
                view.bottomAnchor.constraint(equalTo: self.foodCategoryName.bottomAnchor)
            ]
        }
        self.chevronRightButton.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.foodCategoryName.topAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.frame.width * -0.25),
                view.bottomAnchor.constraint(equalTo: self.foodCategoryName.bottomAnchor)
            ]
        }
        
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.foodCategoryName.bottomAnchor),
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
extension FoodView {
    func setup(foods: [Food], currentMonth: String, category: Category, monthButtonDelegate: MCMonthNavigationButtonDelegate, categorySwipeDelegeta: MCCategorySwipeDelegate, foodDelegate: FoodDetailDelegate?) {
        self.currentMonth = currentMonth
        self.category = category
        
        self.foodCategoryName.text = category.name_category
        self.collectionView.setup(foods: foods, currentMonth: currentMonth, foodDelegate: foodDelegate, favoriteFoodDelegate: nil)
        self.monthTitle.text = currentMonth
        
        self.categorySwipeDelegate = categorySwipeDelegeta
        self.monthButtonDelegate = monthButtonDelegate
        self.setupViewConfiguration()
    }
    
    @objc func chevronLeftAction() {
        self.categorySwipeDelegate?.didClickBackCategory()
    }
    @objc func chevronRightAction() {
        self.categorySwipeDelegate?.didClickNextCategory()
    }
    
    @objc func centeredMonthButtonAction() {
        self.monthButtonDelegate?.didClickMonthButton(currentMonth: "Abril")
    }
}
