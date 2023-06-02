//
 //  FoodViewController.swift
 //  MacroChallenge
 //
 //  Created by Bruno Lafayette on 29/05/23.
 //
 import UIKit

protocol MCMonthNavigationButtonDelegate: AnyObject {
    func didClickMonthButton(currentMonth: String)
    func didSelectNewMonth(month: String)
}

 final class FoodViewController: UIViewController {
     
     weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
     var foods = [Food]()
     var currentMonth: String? = nil
    
     lazy private var foodView = FoodView(frame: self.view.frame)
     
     override func loadView() {
         super.loadView()
         self.view = foodView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.foodView.setup(foods: self.foods, currentMonth: self.currentMonth ?? "Erro mês", monthButtonDelegate: self)
         self.navigationItem.hidesBackButton = true
     }
 }

extension FoodViewController: MCMonthNavigationButtonDelegate {
    func didClickMonthButton(currentMonth: String) {
        let newVC = MonthSelectionViewController()
        newVC.delegate = self
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    
    func didSelectNewMonth(month: String) {
        self.monthUpdatesDelegate?.didChangeMonth(newMonthName: month)
        self.foodView.setup(foods: self.foods, currentMonth: month, monthButtonDelegate: self)
    }
}

//MARK: - Functions here
extension FoodViewController {
    func setup(foods: [Food], currentMonth: String, monthUpdatesDelegate: MCMonthUpdatesDelegate) {
        self.foods = foods
        self.currentMonth = currentMonth
        self.monthUpdatesDelegate = monthUpdatesDelegate
    }
}
