//
//  FilterCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterCollectionView: UICollectionView {
    
    weak var fastFilterDelegate: FastFilterDelegate? = nil
    private var fastFilters = [FastFilterModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterCollectionViewCell")
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

//MARK: - DataSource
extension FilterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fastFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let fastFilter = self.fastFilters[indexPath.row]
        
        if (fastFilter.filterIsSelected ?? false) {
            cell.filterImage.image = UIImage(named: "\(fastFilter.name)Selected")
        } else {
            cell.filterImage.image = UIImage(named: "\(fastFilter.name)")
        }
        
        return cell
    }
    
}

//MARK: - Delegate
extension FilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fastFilter = self.fastFilters[indexPath.row]
        if !(fastFilter.filterIsSelected ?? false)  {
            if fastFilter.idCategory != nil {
                self.fastFilterDelegate?.didClickCategoryFilter(fastFilter: fastFilter)
            }
        }
        if fastFilter.name == "months" {
            self.fastFilterDelegate?.didClickMonthFilter()
        }
    }
}

//MARK: - Functions here
extension FilterCollectionView {
    func setup(fastFilterDelegate: FastFilterDelegate, fastFilters: [FastFilterModel]) {
        self.fastFilterDelegate = fastFilterDelegate
        self.fastFilters = fastFilters
        self.reloadData()
    }
}
