//
//  FilterSelectedCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterSelectedCollectionView: UICollectionView {
    
    lazy var myViewHeightAnchor = self.heightAnchor.constraint(equalToConstant: 0)
    private var choosenFilters = [FastFilterModel]() {
        didSet {
            if self.choosenFilters.isEmpty {
                myViewHeightAnchor.constant = 0
                self.layoutIfNeeded()
            } else {
                myViewHeightAnchor.constant = 40
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundView = .none
        self.backgroundColor = .clear
        self.register(FilterSelectedCollectionViewCell.self, forCellWithReuseIdentifier: "FilterSelectedCollectionViewCell")
        self.dataSource = self
        myViewHeightAnchor.isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - DataSource
extension FilterSelectedCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.choosenFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterSelectedCollectionViewCell", for: indexPath) as! FilterSelectedCollectionViewCell
        cell.lblFilterSelected.text = self.choosenFilters[indexPath.row].name.capitalized
        cell.addLeftBorder(color: .brown, width: 4.0)
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

//MARK: - Functions here
extension FilterSelectedCollectionView {
    func setup(fastFilterDelegate: FastFilterDelegate, choosenFilters: [FastFilterModel]) {
        self.choosenFilters = choosenFilters
        self.reloadData()
    }
}
