//
//  MonthSelectionViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 31/05/23.
//

import UIKit

protocol MCMonthSelectionDelegate: AnyObject {
    func didSelectCell(month: String)
}

class MonthSelectionViewController: UIViewController {
    weak var delegate: MCMonthNavigationButtonDelegate? = nil
    lazy var monthSelectionView = MonthSelectionView(frame: self.view.frame)
    private var months: [String] = [
        "Janeiro",
        "Fevereiro",
        "Março",
        "Abril",
        "Maio",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outubro",
        "Novembro",
        "Dezembro"
    ]
    
    override func loadView() {
        super.loadView()
        self.view = monthSelectionView

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthSelectionView.setupMonthSelectionCollectionView(months: self.months, monthSelectionDelegate: self)
    }
}

extension MonthSelectionViewController: MCMonthSelectionDelegate {
    func didSelectCell(month: String) {
        self.delegate?.didSelectNewMonth(month: month)
        self.dismiss(animated: true)
    }
}
