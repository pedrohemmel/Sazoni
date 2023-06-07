//
//  FilterCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 07/06/23.
//

import UIKit

class FilterCollectionView: UICollectionView {
    weak var openSheetDelegate: OpenSheetDelegate? = nil
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterCollectionViewCell")
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setup(openSheetDelegate: OpenSheetDelegate) {
        self.openSheetDelegate = openSheetDelegate
    }
}

//MARK: - DataSource
extension FilterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        cell.filterImage.image = UIImage(named: "pescada_amarela")
        cell.backgroundColor = .black
        return cell
    }
    
}

//MARK: - Delegate
extension FilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openSheetDelegate?.didClickCell()
    }
}
