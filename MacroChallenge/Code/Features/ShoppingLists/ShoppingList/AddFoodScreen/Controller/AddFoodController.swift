import UIKit

class AddFoodController: UIViewController{
    
    private var addFoodView: AddFoodView
    weak var foodToSelectDelegate: FoodToSelectDelegate? = nil
    var shoppingList: ShoppingListModel
    
    //FastFilter
    private var choosenFilters = [FastFilterModel]()
    private var fastFilters = FastFilter.fastFiltersFavorite
    
    init(shoppingList: ShoppingListModel) {
        self.shoppingList = shoppingList
        FoodManager.shared.filterFoods(with: String(), choosenFilters: [FastFilterModel](), byCategory: nil, currentMonthNumber: FoodManager.shared.getCurrentMonthNumber(), monthSelected:  FoodManager.shared.getCurrentMonth())
        self.addFoodView = AddFoodView(frame: .zero, foods: FoodManager.shared.filteredFoods)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .SZColorPrimaryColor
        
        addFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        addFoodView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        
        addFoodView.collectionView.shoppingList = shoppingList
        addFoodView.collectionView.foodToSelectDelegate = foodToSelectDelegate
        backBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.addFoodView
    }
}

extension AddFoodController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        FoodManager.shared.filterFoods(with: String(), choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: FoodManager.shared.getCurrentMonthNumber(), monthSelected: FoodManager.shared.getCurrentMonth())
        addFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
    func didClickMonthFilter() {
    }
    func selectInitialMonth() {
    }
    func didSelectMonthFilter(monthName: String) {
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        FoodManager.shared.filterFoods(with: String(), choosenFilters: self.choosenFilters, byCategory: nil, currentMonthNumber: FoodManager.shared.getCurrentMonthNumber(), monthSelected: FoodManager.shared.getCurrentMonth())
        addFoodView.collectionView.foods = FoodManager.shared.filteredFoods
    }
}

extension AddFoodController{
    
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.addFoodView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
    }
    
    func backBtn(){
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.setTitle("Voltar", for: .normal)
        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }
}
