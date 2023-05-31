//
//  ExampleViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

protocol MCMonthNavigationButtonDelegate: AnyObject {
    func didClickMonthButton(currentMonth: String)
    func didSelectNewMonth(month: String)
}

class ExampleViewController: UIViewController {
    lazy var nav = {
        let nav = NavigationBarViewComponent()
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        self.setupViewConfiguration()
    }
}

extension ExampleViewController: ViewCode {
    func buildViewHierarchy() {
        self.view.addSubview(self.nav)
    }
    
    func setupConstraints() {
        self.nav.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.nav.monthButtonDelegate = self
        self.nav.setupItems(title: nil, trailingButtonTitle: nil, leadingButtonTitle: nil, centerButtonTitle: "Mês atual")
    }
}

extension ExampleViewController: MCMonthNavigationButtonDelegate {
    func didClickMonthButton(currentMonth: String) {
        let newVC = MonthSelectionViewController()
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    
    func didSelectNewMonth(month: String) {
        
    }
}
