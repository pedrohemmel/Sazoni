
import UIKit

final class FoodViewController: UIViewController {
    
    private var choosenFilters = [FastFilterModel]()
    weak var monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil
    weak var foodDelegate: FoodDetailDelegate? = nil
    private var fastFilters = FastFilter.fastFiltersFavorite
    var currentMonth: String? = nil
    var category: Category = Category(id_category: .zero, name_category: String())
    var categories = [Category]()
     
     private lazy var foodView = FoodView(frame: self.view.frame)
    
    init(monthUpdatesDelegate: MCMonthUpdatesDelegate? = nil, foodDelegate: FoodDetailDelegate? = nil, currentMonth: String? = nil, category: Category, categories: [Category] = [Category]()) {
        self.monthUpdatesDelegate = monthUpdatesDelegate
        self.foodDelegate = foodDelegate
        self.currentMonth = currentMonth
        self.category = category
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func loadView() {
         super.loadView()
         self.view = foodView
         addBackButton()
         addBtnInfo()
     }

     override func viewDidLoad() {
         super.viewDidLoad()
         self.navigationItem.hidesBackButton = true
         self.foodView.changeMonthButton.fastFilterDelegate = self
         self.choosenFilters.append(FastFilterModel(name: category.name_category, idCategory: category.id_category, filterIsSelected: nil))
         self.reloadFastFilterData(fastFilter: self.fastFilters[category.id_category], filterIsSelected: true)
         FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.getCurrentMonth())
         self.foodView.setup(currentMonth: self.currentMonth ?? "Erro mês", category: self.category, foodDelegate: self.foodDelegate)
         self.foodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: fastFilters)
         self.foodView.search.searchDelegate = self
     }
 }

extension FoodViewController: SearchDelegate {
    func search(with searchText: String) {
        FoodManager.shared.filterFoods(with: searchText, choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: self.getCurrentMonthNumber(), monthSelected: self.currentMonth ?? "")
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

//MARK: - Functions here
extension FoodViewController {
    
   
    func getCurrentMonthNumber() -> Int {
        let months = Months.monthArray
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = currentMonth
        return months.firstIndex(where: {$0.lowercased() == nameOfMonth?.lowercased()}) ?? 0

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
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: getCurrentMonthNumber(), monthSelected: currentMonth ?? getCurrentMonth())
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
        
    }
    func didClickMonthFilter() {
        let newVC = MonthSelectionViewController()
        newVC.fastFilterDelegate = self
        newVC.monthSelected = currentMonth ?? getCurrentMonth()
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    func selectInitialMonth() {
        self.choosenFilters.append(FastFilterModel(name: self.getCurrentMonth(), idCategory: nil, filterIsSelected: nil))
        currentMonth = self.getCurrentMonth()
        self.reloadFastFilterData(fastFilter: FastFilterModel(name: "months", idCategory: nil), filterIsSelected: true)
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: getCurrentMonthNumber(), monthSelected: currentMonth ?? getCurrentMonth())
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        currentMonth = monthName
        self.foodView.monthTitle.text = monthName
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: getCurrentMonthNumber(), monthSelected: monthName)
        self.foodView.collectionView.foods = FoodManager.shared.filteredFoods
        self.foodView.collectionView.currentMonth = currentMonth ?? getCurrentMonth()
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        print(fastFilter)
        print(self.choosenFilters)
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        FoodManager.shared.filterFoods(with: "\(self.foodView.search.text ?? String())", choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: getCurrentMonthNumber(), monthSelected: currentMonth ?? getCurrentMonth())
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
