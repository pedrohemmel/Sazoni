
import UIKit
import Combine



class SearchViewController: UIViewController {
    
    var observer: AnyCancellable?
    
    lazy var searchView = SearchView(frame: self.view.frame)
    private var monthSelected = String()
    
    //FastFilter
    var choosenFilters = [FastFilterModel]()
    var fastFilters = FastFilter.fastFilters
    
    //Load food data
    private var dataIsReceived = false
    
    override func loadView() {
        super.loadView()
        self.view = self.searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.search.searchDelegate = self
        
        FoodManager.shared.filterFoods(with: "", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.setup(foods: FoodManager.shared.filteredFoods, currentMonth: self.getCurrentMonth(), foodDelegate: nil, favoriteFoodDelegate: nil)
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        self.selectInitialMonth()
    }
}

extension SearchViewController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        FoodManager.shared.filterFoods(with: "\(self.searchView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.foods = FoodManager.shared.filteredFoods
        
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
        FoodManager.shared.filterFoods(with: "\(self.searchView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        self.choosenFilters.append(FastFilterModel(name: monthName, idCategory: nil, filterIsSelected: nil))
        self.monthSelected = monthName
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.searchView.collectionView.setup(foods: FoodManager.shared.filteredFoods, currentMonth: monthName, foodDelegate: nil, favoriteFoodDelegate: nil)
        FoodManager.shared.filterFoods(with: "\(self.searchView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        FoodManager.shared.filterFoods(with: "\(self.searchView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension SearchViewController: SearchDelegate {
    func search(with searchText: String) {
        FoodManager.shared.filterFoods(with: searchText, choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.searchView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension SearchViewController {
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
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
