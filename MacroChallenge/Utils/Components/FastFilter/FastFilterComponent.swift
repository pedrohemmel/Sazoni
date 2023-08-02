//
//  FastFilterComponent.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FastFilterComponent: UIView {
    lazy var filterSelectedCollectionView: FilterSelectedCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 60)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        
        let filterSelectedCollectionView = FilterSelectedCollectionView(frame: .zero, collectionViewLayout: layout)
        filterSelectedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return filterSelectedCollectionView
    }()
    
    lazy var filterCollectionView: FilterCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
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

//MARK: - Viewcode extension
extension FastFilterComponent: ViewCode {
    func buildViewHierarchy() {
        [self.filterSelectedCollectionView, self.filterCollectionView].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.filterCollectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.filterSelectedCollectionView.topAnchor, constant: -5),
                view.heightAnchor.constraint(equalToConstant: 60)
            ]
        }
        self.filterSelectedCollectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.filterCollectionView.bottomAnchor, constant: 5),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//                view.heightAnchor.constraint(equalToConstant: 40)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
    }
}

