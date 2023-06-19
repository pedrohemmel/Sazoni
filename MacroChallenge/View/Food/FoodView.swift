//
//  FoodView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 01/06/23.
//

import UIKit

class FoodView: UIView {
    
//    weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    weak var monthButtonDelegate: MCMonthNavigationButtonDelegate? = nil
    var currentMonth: String? = nil
    private var foods = [Food]()
    var category = Category(id_category: 0, name_category: "")
    
    //MARK: - Views
    lazy private var monthTitle: UILabel = {
        let monthTitle = UILabel()
        monthTitle.text = self.currentMonth
        monthTitle.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        return monthTitle
    }()
    lazy private var monthTitleBtn: UIButton = {
        let monthTitleButton = UIButton()
        monthTitleButton.addSubview(self.monthTitle)
        monthTitleButton.addTarget(nil, action: #selector(self.centeredMonthButtonAction), for: .touchUpInside)
        monthTitleButton.translatesAutoresizingMaskIntoConstraints = false
        return monthTitleButton
    }()
    
    lazy private var foodSwipeCategoryView: FoodSwipeCategoryView = {
        let foodSwipeCategoryView = FoodSwipeCategoryView(frame: .zero)
        foodSwipeCategoryView.translatesAutoresizingMaskIntoConstraints = false
        return foodSwipeCategoryView
    }()
    
    private lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (self.bounds.width / 3) - 20, height: 180)
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
        [self.monthTitleBtn, self.foodSwipeCategoryView, self.collectionView].forEach({self.addSubview($0)})
    }

    func setupConstraints() {
        self.monthTitleBtn.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.foodSwipeCategoryView.topAnchor)
            ]
        }
        self.monthTitle.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.monthTitleBtn.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: self.monthTitleBtn.centerYAnchor)
            ]
        }
        
        self.foodSwipeCategoryView.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.monthTitleBtn.bottomAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -10),
                view.heightAnchor.constraint(equalToConstant: 25)
            ]
        }
        
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.foodSwipeCategoryView.bottomAnchor),
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
extension FoodView {
    func setup(foods: [Food], currentMonth: String, category: Category, monthButtonDelegate: MCMonthNavigationButtonDelegate, categorySwipeDelegeta: MCCategorySwipeDelegate, foodDelegate: FoodDetailDelegate?) {
        self.foods = foods
        self.currentMonth = currentMonth
        self.category = category
        
        self.foodSwipeCategoryView.setup(selectedCategory: category, categorySwipeDelegate: categorySwipeDelegeta)
        self.collectionView.setup(foods: foods, currentMonth: currentMonth, foodDelegate: foodDelegate)
        self.monthTitle.text = currentMonth
        
        self.monthButtonDelegate = monthButtonDelegate
        self.setupViewConfiguration()
    }
    
    @objc func centeredMonthButtonAction() {
        self.monthButtonDelegate?.didClickMonthButton(currentMonth: "Abril")
    }
}
