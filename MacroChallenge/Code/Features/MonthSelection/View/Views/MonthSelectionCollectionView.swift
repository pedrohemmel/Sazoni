//
//  MonthSelectionCollectionView.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 31/05/23.
//

import UIKit

class MonthSelectionCollectionView: UICollectionView {
    
    weak var monthSelectionDelegate: MCMonthSelectionDelegate? = nil
    private var months: [String] = [String]()
    private var monthSelected: String?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(MonthSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "MonthSelectionCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(months: [String], monthSelectionDelegate: MCMonthSelectionDelegate, monthSelected: String) {
        self.monthSelected = monthSelected
        self.months = months
        self.monthSelectionDelegate = monthSelectionDelegate
    }
}

//MARK: - UICollectionViewDataSource
extension MonthSelectionCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "MonthSelectionCollectionViewCell", for: indexPath) as! MonthSelectionCollectionViewCell
        cell.title.text = self.months[indexPath.row]
        cell.layer.cornerRadius = 10
        if cell.title.text == monthSelected{
            cell.backgroundColor = .SZColorSecundaryColor
            cell.title.textColor = .SZColorBeige
        } else {
            cell.backgroundColor = .SZColorBeige
            cell.title.textColor = .SZColorSecundaryColor
            cell.title.font = .SZFontTextBold
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MonthSelectionCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.monthSelected = self.monthSelectionDelegate?.didSelectCell(month: "\(self.months[indexPath.row])")
    }
}
