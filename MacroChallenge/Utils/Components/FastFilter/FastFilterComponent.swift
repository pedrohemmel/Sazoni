//
//  FastFilterComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//


//Step to create the component
/// Create the collectionview of filters - Feito
/// Create the collectionview of selected filters - Feito
/// Create cell structure of filters collectionview
/// Create cell structure of selected filters collectionview
/// Create the logic of clicking in each filter

import UIKit

class FastFilterComponent: UIView {
    
    
    lazy var filterSelectedCollectionView: FilterSelectedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spaceBetweenItems = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let filterSelectedCollectionView = FilterSelectedCollectionView(frame: .zero, collectionViewLayout: layout)
        filterSelectedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return filterSelectedCollectionView
    }()
    
    lazy var filterCollectionView: FilterCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spaceBetweenItems = 20
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let filterCollectionView = FilterCollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return filterCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FastFilterComponent: ViewCode {
    func buildViewHierarchy() {
        [self.filterSelectedCollectionView, self.filterCollectionView].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        
        self.filterSelectedCollectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.filterCollectionView.topAnchor, constant: -5),
                view.heightAnchor.constraint(equalToConstant: 40)
            ]
        }
        self.filterCollectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.filterSelectedCollectionView.bottomAnchor, constant: 5),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
}

