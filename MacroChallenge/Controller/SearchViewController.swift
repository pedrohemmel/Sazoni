
import UIKit

class SearchViewController: UISearchController {
    
    lazy var searchView = SearchView(frame: self.view.frame)

    
    private var filteredFoods: [Food] = [] {
        didSet {
            self.searchView.gridFood.reloadData()
        }
    }
    
    private var foods = [Food]()
    private var dataIsReceived = false
    lazy private var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.setupViewConfiguration()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupViewConfiguration()
    }
    

}

extension SearchViewController: ViewCode{
    func buildViewHierarchy() {
        view.addSubview(searchView)
    }
    
    func setupConstraints() {}
    
    func setupAdditionalConfiguration() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.searchView.search.searchViewController = self
        
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.filteredFoods = self.foods
            self.searchView.gridFood.foods = self.filteredFoods
        }
    }
}


extension SearchViewController{
    
    func filterFoods(with searchText: String) {
        if searchText.isEmpty {
            filteredFoods = foods
            self.searchView.gridFood.foods = self.filteredFoods
            self.searchView.gridFood.reloadData()
        } else {
            filteredFoods = foods.filter { $0.name_food.lowercased().contains(searchText.lowercased()) || $0.seasonalities[5].state_seasonality.lowercased().contains(searchText.lowercased()) }
            self.searchView.gridFood.foods = self.filteredFoods
            self.searchView.gridFood.reloadData()
        }
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
