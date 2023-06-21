

import UIKit

class FavoriteFoodViewController: UIViewController {
    
    lazy var favoriteFoodView = FavoriteFoodView(frame: self.view.frame)
    weak var foodDelegate: FoodDetailDelegate? = nil
    private var listFood: [Food] = [Food]()
    private var currentMonth: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteFoodView.setup(foods: self.listFood, currentMonth: currentMonth, foodDelegate: foodDelegate)
    }

    override func loadView() {
        super.loadView()
        self.view = self.favoriteFoodView
    }
    

}

extension FavoriteFoodViewController {
    
    func setup(food: [Food], currentMonth: String, foodDelegate: FoodDetailDelegate?){
        self.listFood = food
        self.currentMonth = currentMonth
        self.foodDelegate = foodDelegate
 
    }
}

