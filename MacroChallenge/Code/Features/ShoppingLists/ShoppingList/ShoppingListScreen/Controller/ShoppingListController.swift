
import UIKit
import Combine

class ShoppingListController: UIViewController {
    
    lazy var shoppingListView = ShoppingListView()
    
    //FastFilter
    private var choosenFilters = [FastFilterModel]()
    private var fastFilters = FastFilter.fastFiltersFavorite
    
    private var shoppingList: ShoppingListModel
    
    init(shoppingList: ShoppingListModel, frame: CGRect) {
        self.shoppingList = shoppingList
        FoodManager.shared.filterShoppingFoods(itemsShoppingListModel: shoppingList.itemShoppingListModel, choosenFilters: [FastFilterModel]())
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        self.shoppingListView.collectionView.foods = FoodManager.shared.filteredFoods
        self.shoppingListView.collectionView.shoppingList = shoppingList
    }
    
    override func loadView() {
        self.view = self.shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .SZColorPrimaryColor
        
        self.shoppingListView.collectionView.foodToSelectDelegate = self
        self.shoppingListView.title.text = shoppingList.name
        
        self.shoppingListView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.shoppingListView.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
        self.shoppingListView.collectionView.foodToSelectDelegate = self
        
        backBtn()
        addFoodBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListController: AddFoodDelegate {
    func didClickAddNewFood() {
        
    }
}

extension ShoppingListController: FoodToSelectDelegate {
    func didUpdateShoppingList(shoppingList: ShoppingListModel, food: Food) {
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            let newShoppingLists = ShoppingListManager.shared.shoppingLists
            self.shoppingList = newShoppingLists[newShoppingLists.firstIndex(where: { $0.id == self.shoppingList.id }) ?? 0]
            FoodManager.shared.filterShoppingFoods(itemsShoppingListModel: self.shoppingList.itemShoppingListModel, choosenFilters: self.choosenFilters)
            self.shoppingListView.collectionView.foods = FoodManager.shared.filteredFoods
        }
    }
}

extension ShoppingListController: FastFilterDelegate {
    func selectInitialMonth() {
    }
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: true)
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            let newShoppingLists = ShoppingListManager.shared.shoppingLists
            self.shoppingList = newShoppingLists[newShoppingLists.firstIndex(where: { $0.id == self.shoppingList.id }) ?? 0]
            FoodManager.shared.filterShoppingFoods(itemsShoppingListModel: self.shoppingList.itemShoppingListModel, choosenFilters: self.choosenFilters)
            self.shoppingListView.collectionView.foods = FoodManager.shared.filteredFoods
        }
    }
    func didClickMonthFilter() {
    }
    func didSelectMonthFilter(monthName: String) {
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.reloadFastFilterData(fastFilter: fastFilter, filterIsSelected: false)
        ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
            let newShoppingLists = ShoppingListManager.shared.shoppingLists
            self.shoppingList = newShoppingLists[newShoppingLists.firstIndex(where: { $0.id == self.shoppingList.id }) ?? 0]
            FoodManager.shared.filterShoppingFoods(itemsShoppingListModel: self.shoppingList.itemShoppingListModel, choosenFilters: self.choosenFilters)
            self.shoppingListView.collectionView.foods = FoodManager.shared.filteredFoods
        }
    }
}

extension ShoppingListController {
    func reloadFastFilterData(fastFilter: FastFilterModel, filterIsSelected: Bool) {
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = filterIsSelected
        self.shoppingListView.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
    }
    
    func getCurrentMonthNumber() -> Int {
        let months = Months.monthArray
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return months.firstIndex(where: {$0.lowercased() == nameOfMonth.lowercased()}) ?? 0
    }
    
    func backBtn() {
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.setTitle("Voltar", for: .normal)
        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func addFoodBtn(){
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setTitle("Adicionar", for: .normal)
        btn.titleLabel?.font = .SZFontTextBold
        btn.addTarget(self, action: #selector(addFoodAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func addFoodAction() {
        let newVC = AddFoodController(shoppingList: shoppingList)
    
        newVC.foodToSelectDelegate = self
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
