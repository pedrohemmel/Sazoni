

import UIKit
import Combine

protocol FavoriteFoodDelegate: AnyObject {
    func didSelectFood(food: Food)
    func didSelectFavoriteButton()
}

class FavoriteFoodViewController: UIViewController {
    
    lazy var favoriteFoodView = FavoriteFoodView(frame: self.view.frame)
    private var currentMonth: String = String()
    
    //FastFilter
    private var choosenFilters = [FastFilterModel]()
    private var fastFilters = FastFilter.fastFiltersFavorite
    
    private lazy var favoriteFoodSubscriber = Subscribers.Assign(object: favoriteFoodView.collectionView, keyPath: \.foods)
    
    init(currentMonth: String) {
        super.init(nibName: nil, bundle: nil)
        self.currentMonth = currentMonth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionFoodsPublisher.subscribe(favoriteFoodSubscriber)
        
        self.favoriteFoodView.collectionView.setup(foods: FoodManager.shared.favoriteFoods, currentMonth: currentMonth, foodDelegate: nil, favoriteFoodDelegate: self)
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        self.filterFoods()
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.favoriteFoodView
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
    
    func filterFoods() {
        FoodManager.shared.getFavoriteFoods()
        FoodManager.shared.filteredFoods = FoodManager.shared.favoriteFoods

        for filter in self.choosenFilters {
            if !self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                FoodManager.shared.filteredFoods = FoodManager.shared.filteredFoods.filter({ food in
                    self.choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                })
            }
        }

        FoodManager.shared.filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: FoodManager.shared.filteredFoods, currentMonth: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
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
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}
