
import UIKit

final class FoodViewController: UIViewController {
    
    private var choosenFilters = [FastFilterModel]()
    private lazy var foodView = FoodView(frame: self.view.frame)
    weak var foodDelegate: FoodDetailDelegate?
    private var fastFilters = FastFilter.fastFiltersFavorite
    private var currentMonth: String?
    private var category: Category
    private var filteredFoods = [Food]()
    
    private var monthSelected = String()
    
    init(currentMonth: String, filteredFoods: [Food], category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        self.foodDelegate = self
        self.currentMonth = currentMonth
        self.filteredFoods = self.filterFoods(foods: filteredFoods, category: category, currentMonth: currentMonth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = foodView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodView.setup(foods: self.filteredFoods, currentMonth: self.currentMonth ?? "Erro mês", category: self.category, foodDelegate: self.foodDelegate)
        self.foodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        addBackButton()
        addBtnInfo()
    }
}


//MARK: - Functions here
extension FoodViewController {
    
    func filterFoods(foods: [Food], category: Category, currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        newFoods = self.filterFoodsByCategory(foods: foods, category: category)
        newFoods = self.orderFoodsByHighQualityInCurrentMonth(foods: newFoods, currentMonth: currentMonth)
        return newFoods
    }
    
    func filterFoodsByCategory(foods: [Food], category: Category) -> [Food] {
        return foods.filter({ food in
            return food.category_food.id_category == category.id_category
        })
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

extension FoodViewController: FastFilterDelegate{
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
    
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.foodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        //        self.favoriteFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    
    func deleteMonthIfItExists() {
        let months = Months.monthArray
        for month in months {
            if self.choosenFilters.contains(where: { $0.name == month }) {
                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
            }
        }
    }
    
    func filterFoods() {
        
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
