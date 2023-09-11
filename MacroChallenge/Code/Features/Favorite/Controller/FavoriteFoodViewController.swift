

import UIKit
import Combine


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
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.setup(foods: FoodManager.shared.filteredFoods, currentMonth: currentMonth, foodDelegate: nil, favoriteFoodDelegate: self)
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
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension FavoriteFoodViewController: FastFilterDelegate {
    func selectInitialMonth() {
        self.choosenFilters.append(FastFilterModel(name: self.getCurrentMonth(), idCategory: nil, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
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
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        FoodManager.shared.filterFavoriteFoods(choosenFilters: self.choosenFilters, monthSelected: self.currentMonth)
        self.favoriteFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension FavoriteFoodViewController {
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.favoriteFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
    }
    
    func deleteMonthIfItExists() {
//        let months = Months.monthArray
//        for month in months {
//            if self.choosenFilters.contains(where: { $0.name == month }) {
//                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
//            }
//        }
    }
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}
