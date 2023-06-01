//
 //  FoodViewController.swift
 //  MacroChallenge
 //
 //  Created by Bruno Lafayette on 29/05/23.
 //
 import UIKit


 final class FoodViewController: UIViewController {
     
     var foods = [Food]()
     private var dataIsReceived = false
     lazy private var foodManager = FoodManager(response: {
         self.dataIsReceived = true
         self.getFood()
     })
     
     lazy private var foodView = FoodView(frame: self.view.frame)
     
     override func loadView() {
         super.loadView()
         self.view = foodView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.getFood()
     }
 }

//MARK: - Functions here
extension FoodViewController {
    func getFood() {
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.foodView.setup(foods: self.foods)
        }
    }
}
