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
    
    weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    var currentMonth: String? = nil
    
    //MARK: - Views
    lazy var nav = {
        let nav = NavigationBarViewComponent()
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    lazy private var monthTitle: UILabel = {
        let monthTitle = UILabel()
        monthTitle.text = self.currentMonth
        monthTitle.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        return monthTitle
    }()
    lazy private var monthTitleBtn: UIButton = {
        let monthTitleButton = UIButton()
        monthTitleButton.addSubview(self.monthTitle)
        monthTitleButton.translatesAutoresizingMaskIntoConstraints = false
        return monthTitleButton
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
        
        self.monthTitleBtn.setupConstraints { view in
            [
                view.widthAnchor.constraint(equalToConstant: self.monthTitle.intrinsicContentSize.width)
            ]
        }
        self.monthTitle.setupConstraints { view in
            [
                view.centerXAnchor.constraint(equalTo: self.monthTitleBtn.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: self.monthTitleBtn.centerYAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.nav.monthButtonDelegate = self
        self.nav.setupItems(title: nil, trailingButtonTitle: nil, leadingButtonTitle: nil, centerButtonTitle: nil, centeredMonthButton: self.monthTitleBtn)
    }
}

extension ExampleViewController: MCMonthNavigationButtonDelegate {
    func didClickMonthButton(currentMonth: String) {
        let newVC = MonthSelectionViewController()
        newVC.delegate = self
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    
    func didSelectNewMonth(month: String) {
        self.monthUpdatesDelegate?.didChangeMonth(newMonthName: month)
        self.monthTitle.text = self.currentMonth
        self.setupViewConfiguration()
    }
}

//MARK: - Functions
extension ExampleViewController {
    func setup(monthUpdatesDelegate: MCMonthUpdatesDelegate, currentMonth: String) {
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.currentMonth = currentMonth
    }
}
