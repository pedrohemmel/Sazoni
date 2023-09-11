//
//  MonthSelectionViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 31/05/23.
//

import UIKit

protocol MCMonthSelectionDelegate: AnyObject {
    func didSelectCell(month: String) -> String
}

class MonthSelectionViewController: UIViewController {
    
    weak var delegate: MCMonthNavigationButtonDelegate? = nil
    weak var fastFilterDelegate: FastFilterDelegate? = nil
    var monthSelected = String()
    lazy var monthSelectionView = MonthSelectionView(frame: self.view.frame)
    private var months = Months.monthArray
    
    override func loadView() {
        super.loadView()
        self.view = monthSelectionView

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthSelectionView.setupMonthSelectionCollectionView(months: self.months, monthSelectionDelegate: self, monthSelected: self.monthSelected)
    }
}

extension MonthSelectionViewController: MCMonthSelectionDelegate {
    func didSelectCell(month: String) -> String{
        self.delegate?.didSelectNewMonth(month: month)
        //print("________-------------____________ENTREI AQUIIIIIII_____________------------ Mes selecionado = \(month)" )

        self.fastFilterDelegate?.didSelectMonthFilter(monthName: month)
        self.dismiss(animated: true)
        return month
    }
}
