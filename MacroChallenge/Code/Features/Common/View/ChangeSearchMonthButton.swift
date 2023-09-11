//
//  changeSearchMonthButton.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 11/09/23.
//

import UIKit

class ChangeSearchMonthButton: UIButton{
    
    weak var fastFilterDelegate: FastFilterDelegate? = nil
    
    @objc private func changeMonth(){
//        let sheetMonth = MonthSelectionViewController()
//        sheetMonth.sheetPresentationController?.detents = [.medium()]
//        if let rootViewController = window?.rootViewController {
//            rootViewController.present(sheetMonth, animated: true)
//        }
        fastFilterDelegate?.didClickMonthFilter()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.setImage(UIImage(systemName: "calendar"), for: .normal)
        self.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        self.tintColor = .SZColorBeige
        self.addTarget(self, action: #selector(changeMonth), for: .touchUpInside)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.SZColorBeige?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
