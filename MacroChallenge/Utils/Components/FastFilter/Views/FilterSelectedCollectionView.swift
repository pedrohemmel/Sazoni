//
//  FilterSelectedCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterSelectedCollectionView: UICollectionView {
    weak private var fastFilterDelegate: FastFilterDelegate? = nil
    private var choosenFilters = [FastFilterModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FilterSelectedCollectionViewCell.self, forCellWithReuseIdentifier: "FilterSelectedCollectionViewCell")
        self.delegate = self
        self.dataSource = self
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
        return cell
    }
    
}

//MARK: - Delegate
extension FilterSelectedCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: - Functions here
extension FilterSelectedCollectionView {
    func setup(fastFilterDelegate: FastFilterDelegate, choosenFilters: [FastFilterModel]) {
        self.fastFilterDelegate = fastFilterDelegate
        self.choosenFilters = choosenFilters
        self.reloadData()
    }
}
