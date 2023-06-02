    //
//  FoodSwipeCategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 02/06/23.
//

import UIKit

class FoodSwipeCategoryView: UIView {
    
    weak var categorySwipeDelegate: MCCategorySwipeDelegate? = nil
    private var selectedCategory: Category? = nil
    
    lazy var foodCategoryName: UILabel = {
        let foodCategoryName = UILabel()
        foodCategoryName.text = self.selectedCategory?.name_category ?? ""
        foodCategoryName.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        foodCategoryName.translatesAutoresizingMaskIntoConstraints = false
        return  foodCategoryName
    }()
    lazy var chevronLeftButton: UIButton = {
        let chevronLeftButton = UIButton()
        chevronLeftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        chevronLeftButton.addTarget(nil, action: #selector(self.chevronLeftAction), for: .touchUpInside)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronLeftButton
    }()
    lazy var chevronRightButton: UIButton = {
        let chevronRightButton = UIButton()
        chevronRightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronRightButton.addTarget(nil, action: #selector(self.chevronLeftAction), for: .touchUpInside)
        chevronRightButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronRightButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ViewCode
extension FoodSwipeCategoryView: ViewCode {
    func buildViewHierarchy() {
        [self.foodCategoryName, self.chevronLeftButton, self.chevronRightButton].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.chevronLeftButton.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.trailingAnchor.constraint(equalTo: self.foodCategoryName.leadingAnchor, constant: -20)
            ]
        }
        self.chevronRightButton.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: self.foodCategoryName.trailingAnchor, constant: 20)
            ]
        }
        
        self.foodCategoryName.setupConstraints { view in
            [
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.leadingAnchor.constraint(equalToSystemSpacingAfter: self.chevronLeftButton.trailingAnchor, multiplier: 20),
                view.trailingAnchor.constraint(equalTo: self.chevronRightButton.leadingAnchor, constant: -20)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
}

//MARK: - Functions here
extension FoodSwipeCategoryView {
    func setup(selectedCategory: Category, categorySwipeDelegate: MCCategorySwipeDelegate) {
        self.selectedCategory = selectedCategory
        self.foodCategoryName.text = selectedCategory.name_category
        self.categorySwipeDelegate = categorySwipeDelegate
        self.setupViewConfiguration()
    }
    
    @objc func chevronLeftAction() {
        self.categorySwipeDelegate?.didClickBackCategory()
    }
    @objc func chevronRightAction() {
        self.categorySwipeDelegate?.didClickNextCategory()
    }
}

