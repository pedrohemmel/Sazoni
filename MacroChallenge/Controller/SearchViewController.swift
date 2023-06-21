
import UIKit

protocol FastFilterDelegate: AnyObject {
    func didClickCategoryFilter(fastFilter: FastFilterModel)
    func didClickMonthFilter()
    func didSelectMonthFilter(monthName: String)
    func didDeleteFilter(fastFilter: FastFilterModel)
}

protocol FoodDetailDelegate: AnyObject{
    func selectFood(food: Food)
}

class SearchViewController: UISearchController {
    
    lazy var searchView = SearchView(frame: self.view.frame)
    
    //For collectionViewOfFoods
    private var filteredFoods: [Food] = [] {
        didSet {
            self.searchView.collectionView.reloadData()
        }
    }
    
    //FastFilter
    private var choosenFilters = [FastFilterModel]()
    private var fastFilters = [
        FastFilterModel(name: "months", idCategory: nil, filterIsSelected: false),
        FastFilterModel(name: "fruits", idCategory: 0, filterIsSelected: false),
        FastFilterModel(name: "greenstuff", idCategory: 1, filterIsSelected: false),
        FastFilterModel(name: "greens", idCategory: 2, filterIsSelected: false),
        FastFilterModel(name: "fished", idCategory: 3, filterIsSelected: false)
    ]
    
    //Load food data
    private var foods = [Food]()
    private var dataIsReceived = false
    lazy private var foodManager = FoodManager(response: {
        self.dataIsReceived = true
        self.setupViewConfiguration()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
    }
}

extension SearchViewController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        self.filterFoods(with: "\(self.searchView.search.text ?? "")")
    }
    func didClickMonthFilter() {
        let newVC = MonthSelectionViewController()
        newVC.fastFilterDelegate = self
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        self.choosenFilters.append(FastFilterModel(name: monthName, idCategory: nil, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.filterFoods(with: "\(self.searchView.search.text ?? "")")
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        self.filterFoods(with: "\(self.searchView.search.text ?? "")")
    }
}

extension SearchViewController: ViewCode{
    func buildViewHierarchy() {
        view.addSubview(searchView)
        
    }
    
    func setupConstraints() {}
    
    func setupAdditionalConfiguration() {
        self.searchView.search.searchViewController = self
        
        if !self.dataIsReceived {
            self.foodManager.fetchFood()
        } else {
            self.foods = self.foodManager.foods
            self.filteredFoods = self.foods
            self.searchView.collectionView.foods = self.filteredFoods
        }
        
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
}

extension SearchViewController{
    
    func filterFoods(with searchText: String) {
        self.filteredFoods = self.foods
        
        if !searchText.isEmpty {
            self.filteredFoods = filteredFoods.filter { $0.name_food.lowercased().contains(searchText.lowercased()) ||
                $0.seasonalities[5].state_seasonality.lowercased().contains(searchText.lowercased()) ||
                $0.category_food.name_category.lowercased().contains(searchText.lowercased())
            }
        }
        
        for filter in self.choosenFilters {
            if self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                self.filteredFoods = self.filteredFoods.filter({
                    $0.seasonalities[$0.seasonalities.firstIndex(where: {$0.month_name_seasonality == filter.name}) ?? 0].state_seasonality == "Alta" ||
                    $0.seasonalities[$0.seasonalities.firstIndex(where: {$0.month_name_seasonality == filter.name}) ?? 0].state_seasonality == "Média"
                })
            } else {
                self.filteredFoods = self.filteredFoods.filter({ food in
                    self.choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                })
            }
        }
        
        self.searchView.collectionView.foods = self.filteredFoods
        self.searchView.collectionView.reloadData()
    }
    
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.searchView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.searchView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    
    func verifyIfFilterIsMonth(nameOfFilter: String) -> Bool {
        let months = [
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
        return months.contains(nameOfFilter)
    }
    
    func deleteMonthIfItExists() {
        let months = [
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
        
        for month in months {
            if self.choosenFilters.contains(where: { $0.name == month }) {
                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
