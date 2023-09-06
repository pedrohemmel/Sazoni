
import UIKit

final class FoodViewController: UIViewController {
    private var choosenFilters = [FastFilterModel]()
    weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    weak var foodDelegate: FoodDetailDelegate? = nil
    private var fastFilters = FastFilter.fastFiltersFavorite
    var currentMonth: String? = nil
    var monthSelected = String()
    var category: Category = Category(id_category: .zero, name_category: String())
    var categories = [Category]()
     
     private lazy var foodView = FoodView(frame: self.view.frame)
     
     override func loadView() {
         super.loadView()
         self.view = foodView
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.foodView.setup(currentMonth: self.currentMonth ?? "Erro mês", category: self.category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
         self.foodView.search.searchDelegate = self
         self.navigationItem.hidesBackButton = true
     }
 }

extension FoodViewController: SearchDelegate {
    func search(with searchText: String) {
        FoodManager.shared.filterFoods(with: searchText, choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? "")
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension FoodViewController: MCCategorySwipeDelegate {
    func didClickBackCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        if currentCategoryIndex > 0 {
            self.category = self.categories[currentCategoryIndex - 1]
        }
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: self.category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? String())
        self.foodView.setup(currentMonth: self.currentMonth ?? "", category: category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
    func didClickNextCategory() {
        let currentCategoryIndex = self.categories.firstIndex(where: {$0.id_category == self.category.id_category}) ?? 0
        let lastIndexOfCategories = self.categories.firstIndex(where: {$0.id_category == self.categories.last?.id_category}) ?? 0
        if currentCategoryIndex < lastIndexOfCategories {
            self.category = self.categories[currentCategoryIndex + 1]
        }
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: self.category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? String())
        self.foodView.setup(currentMonth: self.currentMonth ?? String(), category: category, categorySwipeDelegeta: self, foodDelegate: self.foodDelegate)
    }
    
}

//MARK: - Functions here
extension FoodViewController {
    func setup(currentMonth: String, monthUpdatesDelegate: MCMonthUpdatesDelegate?, category: Category, categories: [Category], foodDelegate: FoodDetailDelegate?) {
        self.currentMonth = currentMonth
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.category = category
        self.categories = categories
        self.foodDelegate = foodDelegate
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: category, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: currentMonth)
    }
    
   
    func getCurrentMonthNumber() -> Int {
        let months = Months.monthArray
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return months.firstIndex(where: {$0.lowercased() == nameOfMonth.lowercased()}) ?? 0

    }
    
    func addBtnInfo(){
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        backButton.tintColor = .SZColorBeige
        backButton.addTarget(self, action: #selector(self.showInfoView(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    
    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .SZColorBeige
        backButton.setTitle("Voltar", for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInfoView(_ sender: UIButton){
        let infoView = InfoController()
        infoView.sheetPresentationController?.detents = [.large()]
        self.present(infoView, animated: true)
    }
    
    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}

extension FoodViewController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
        
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
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        self.choosenFilters.append(FastFilterModel(name: monthName, idCategory: nil, filterIsSelected: nil))
        self.monthSelected = monthName
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        self.foodView.collectionView.setup(foods: FoodManager.shared.filteredFoods, currentMonth: monthName, foodDelegate: nil, favoriteFoodDelegate: nil)
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.monthSelected)
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}


extension FoodViewController {
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.foodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
    }
    
    func deleteMonthIfItExists() {
        let months = Months.monthArray
        for month in months {
            if self.choosenFilters.contains(where: { $0.name == month }) {
                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
            }
        }
    }
}

extension FoodViewController: FoodDetailDelegate{
    func selectFood(food: Food) {
        self.view.endEditing(true)
        let detailVC = DetailSheetViewController(food)
        detailVC.sheetPresentationController?.detents = [.large()]
        self.present(detailVC, animated: true)
    }
}
