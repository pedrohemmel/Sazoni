

import UIKit

class FavoriteFoodViewController: UIViewController {
    
    lazy var favoriteFoodView = FavoriteFoodView(frame: self.view.frame)
    weak var foodDelegate: FoodDetailDelegate? = nil
    private var listFood: [Food] = [Food]()
    private var currentMonth: String = ""
    
    //For collectionViewOfFoods
    private var filteredFoods: [Food] = [] {
        didSet {
            self.favoriteFoodView.collectionView.reloadData()
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        self.favoriteFoodView.collectionView.setup(foods: self.listFood, currentMonth: currentMonth, foodDelegate: foodDelegate)
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

extension FavoriteFoodViewController: FastFilterDelegate {
    
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        self.filterFoods()
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
        self.filterFoods()
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        self.filterFoods()
    }
    
}

extension FavoriteFoodViewController {
    
    func filterFoods() {
        self.filteredFoods = self.listFood
        
        
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
        
        self.favoriteFoodView.collectionView.foods = self.filteredFoods
        self.favoriteFoodView.collectionView.reloadData()
    }
    
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
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
}
