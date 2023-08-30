

import UIKit

protocol FavoriteFoodDelegate: AnyObject {
    func didSelectFood(food: Food)
    func didSelectFavoriteButton()
}

class FavoriteFoodViewController: UIViewController {
    
    lazy var favoriteFoodView = FavoriteFoodView(frame: self.view.frame)
    private let favorite = FavoriteList.shared
    var listOfFavoriteFoodsIDs = [Int]()
    private var listFood: [Food] = [Food]()
    private var currentMonth: String = ""
        
    //For collectionViewOfFoods
     var filteredFoods: [Food] = [] {
        didSet {
            self.favoriteFoodView.collectionView.reloadData()
        }
    }
    
    //FastFilter
    private var choosenFilters = [FastFilterModel]()
    private var fastFilters = [
        FastFilterModel(name: "Frutas", idCategory: 0, filterIsSelected: false),
        FastFilterModel(name: "Legumes", idCategory: 1, filterIsSelected: false),
        FastFilterModel(name: "Verduras", idCategory: 2, filterIsSelected: false),
        FastFilterModel(name: "Pescados", idCategory: 3, filterIsSelected: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteFoodView.collectionView.setup(foods: self.getFavoriteFoods(), currentMonth: currentMonth, foodDelegate: nil, favoriteFoodDelegate: self)
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        self.listOfFavoriteFoodsIDs = self.favorite.getListOfFoods()
        self.filterFoods()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.favoriteFoodView
    }
}

extension FavoriteFoodViewController {
    func setup(food: [Food], currentMonth: String){
        self.listFood = food
        self.currentMonth = currentMonth
    }
}

extension FavoriteFoodViewController: FavoriteFoodDelegate {
    func didSelectFood(food: Food) {
        let detailVC = DetailSheetViewController(food)
        detailVC.favoriteFoodDelegate = self
        detailVC.sheetPresentationController?.detents = [.large()]
        detailVC.sheetPresentationController?.prefersGrabberVisible = true
        self.present(detailVC, animated: true)
    }
    
    func didSelectFavoriteButton() {
        self.filterFoods()
    }
}

extension FavoriteFoodViewController: FastFilterDelegate {
    func selectInitialMonth() {
        self.choosenFilters.append(FastFilterModel(name: self.getCurrentMonth(), idCategory: nil, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.filterFoods()
    }
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
    
    func getFavoriteFoods() -> [Food] {
        return listFood.filter({ self.listOfFavoriteFoodsIDs.contains($0.id_food) })
    }
    
    func filterFoods() {
        
        self.listOfFavoriteFoodsIDs = self.favorite.getListOfFoods()
        self.filteredFoods = self.getFavoriteFoods()

        for filter in self.choosenFilters {
            if !self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                self.filteredFoods = self.filteredFoods.filter({ food in
                    self.choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                })
            }
        }

        self.filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: self.filteredFoods, currentMonth: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = self.filteredFoods
        self.favoriteFoodView.collectionView.reloadData()
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
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}
