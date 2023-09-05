//
//  SeasonalityCollectionViewCell.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 13/06/23.
//

import UIKit

class SeasonalityCollectionViewCell: UICollectionViewCell {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = .SZCornerRadiusSmallShape
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 0.467, green: 0.358, blue: 0.262, alpha: 1).cgColor
        view.backgroundColor = .SZColorSecundaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var month: UILabel = {
        let text = UILabel()
        text.font = .SZFontText
        text.textColor = .SZColorBeige
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var availability: UILabel = {
        let text = UILabel()
        text.font = .SZFontText
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        return text
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SeasonalityCollectionViewCell: ViewCode{
    func buildViewHierarchy() {
        contentView.addSubview(self.container)
        [self.month, self.subContainer].forEach({self.container.addSubview($0)})
        self.subContainer.addSubview(self.availability)
    }
    
    func setupConstraints() {
        self.container.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]}
        self.month.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.container.safeAreaLayoutGuide.topAnchor, constant: 8),
                view.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 5),
                view.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -5),
                view.bottomAnchor.constraint(equalTo: self.subContainer.safeAreaLayoutGuide.topAnchor, constant: -8)
            ]}
        self.subContainer.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.month.safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.container.leadingAnchor, constant: 1),
                view.trailingAnchor.constraint(equalTo: self.container.trailingAnchor, constant: -1),
                view.bottomAnchor.constraint(equalTo: self.container.bottomAnchor)
            ]}
        
        
        self.availability.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.subContainer.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.subContainer.leadingAnchor, constant: 5),
                view.trailingAnchor.constraint(equalTo: self.subContainer.trailingAnchor, constant: -5),
                view.bottomAnchor.constraint(equalTo: self.subContainer.bottomAnchor)
            ]}
        
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
