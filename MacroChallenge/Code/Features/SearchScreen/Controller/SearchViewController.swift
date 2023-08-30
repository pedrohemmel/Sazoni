
import UIKit

protocol FastFilterDelegate: AnyObject {
    func didClickCategoryFilter(fastFilter: FastFilterModel)
    func didClickMonthFilter()
    func selectInitialMonth()
    func didSelectMonthFilter(monthName: String)
    func didDeleteFilter(fastFilter: FastFilterModel)
}

protocol FoodDetailDelegate: AnyObject{
    func selectFood(food: Food)
}

class SearchViewController: UISearchController {
    
    lazy var searchView = SearchView(frame: self.view.frame)
    private var monthSelected = String()
    
    //For collectionViewOfFoods
    private var filteredFoods: [Food] = [] {
        didSet {
            self.searchView.collectionView.reloadData()
        }
    }
    
    //FastFilter
    var choosenFilters = [FastFilterModel]()
    var fastFilters = FastFilter.fastFilters
    
    //Load food data
    private var foods = [Food]()
    private var dataIsReceived = false
    private lazy var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.setupView()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.selectInitialMonth()
    }
}

extension SearchViewController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        self.filterFoods(with: "\(self.searchView.search.text ?? String())")
    }
    func didClickMonthFilter() {
        let newVC = MonthSelectionViewController()
        newVC.fastFilterDelegate = self
        newVC.monthSelected = monthSelected
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    func selectInitialMonth() {
        self.choosenFilters.append(FastFilterModel(name: self.getCurrentMonth(), idCategory: nil, filterIsSelected: nil))
        self.monthSelected = self.getCurrentMonth()
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.filterFoods(with: "\(self.searchView.search.text ?? String())")
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        self.choosenFilters.append(FastFilterModel(name: monthName, idCategory: nil, filterIsSelected: nil))
        self.monthSelected = monthName
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.searchView.collectionView.setup(foods: self.foods, currentMonth: monthName, foodDelegate: nil, favoriteFoodDelegate: nil)
        self.filterFoods(with: "\(self.searchView.search.text ?? String())")
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        self.filterFoods(with: "\(self.searchView.search.text ?? String())")
    }
}


extension SearchViewController{
    
    //Refatorar essa função
    func setupView() {
        view.addSubview(searchView)
        self.searchView.search.searchViewController = self
        
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.filteredFoods = self.foods
            self.searchView.collectionView.setup(foods: self.foods, currentMonth: self.getCurrentMonth(), foodDelegate: nil, favoriteFoodDelegate: nil)
            self.filterFoods(with: "")
        }
        
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    
    func filterFoods(with searchText: String) {
        self.filteredFoods = self.foods
        
        if !searchText.isEmpty {
            self.filteredFoods = filteredFoods.filter { $0.name_food.lowercased().contains(searchText.lowercased()) ||
                $0.seasonalities[self.getCurrentMonthNumber()].state_seasonality.lowercased().contains(searchText.lowercased()) ||
                $0.category_food.name_category.lowercased().contains(searchText.lowercased())
            }
        }
        
        
        for filter in self.choosenFilters {
            if !self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                self.filteredFoods = self.filteredFoods.filter({ food in
                    self.choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                })
            }
        }
        
        self.filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: self.filteredFoods, currentMonth: self.monthSelected)
        
        self.searchView.collectionView.foods = self.filteredFoods
        self.searchView.collectionView.reloadData()
    }
    
    func orderFoodsByHighQualityInCurrentMonth(foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Alta", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Média", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Baixa", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Muito baixa", foods: foods, currentMonth: currentMonth))
        return newFoods
    }
    
    func getFoodsInCurrentMonthWithState(state: String, foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        for food in foods {
            for seasonality in food.seasonalities {
                if seasonality.month_name_seasonality.lowercased() == currentMonth.lowercased() {
                    if seasonality.state_seasonality.lowercased() == state.lowercased() {
                        newFoods.append(food)
                    }
                }
            }
        }
        newFoods = newFoods.sorted(by: { $0.name_food < $1.name_food })
        return newFoods
        
    }
    
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    
    func verifyIfFilterIsMonth(nameOfFilter: String) -> Bool {
        let months = Months.monthArray
        return months.contains(nameOfFilter)
    }
    
    func deleteMonthIfItExists() {
        let months = Months.monthArray
        
        for month in months {
            if self.choosenFilters.contains(where: { $0.name == month }) {
                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
            }
        }
    }
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
    
    func getCurrentMonthNumber() -> Int {
        let months = Months.monthArray
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return months.firstIndex(where: {$0.lowercased() == nameOfMonth.lowercased()}) ?? 0
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
