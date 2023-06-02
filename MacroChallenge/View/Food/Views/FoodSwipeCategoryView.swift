    //
//  FoodSwipeCategoryView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 02/06/23.
//

import UIKit

class FoodSwipeCategoryView: UIView {
    
    private var categorySelected: Category? = nil
    
    lazy var foodCategoryName: UILabel = {
        let foodCategoryName = UILabel()
        foodCategoryName.text = self.categorySelected?.name_category ?? ""
        foodCategoryName.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        foodCategoryName.translatesAutoresizingMaskIntoConstraints = false
        return  foodCategoryName
    }()
    lazy var chevronLeftButton: UIButton = {
        let chevronLeftButton = UIButton()
        chevronLeftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronLeftButton
    }()
    lazy var chevronRightButton: UIButton = {
        let chevronRightButton = UIButton()
        chevronRightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronRightButton.translatesAutoresizingMaskIntoConstraints = false
        return chevronRightButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    func setup(categorySelected: Category) {
        self.categorySelected = categorySelected
    }
}

