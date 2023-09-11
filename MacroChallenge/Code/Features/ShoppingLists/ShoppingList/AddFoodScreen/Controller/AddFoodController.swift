import UIKit

class AddFoodController: UIViewController{
    
    private var addFoodView: AddFoodView
    weak var foodToSelectDelegate: FoodToSelectDelegate? = nil
    var shoppingList: ShoppingListModel
    
    init(shoppingList: ShoppingListModel) {
        self.shoppingList = shoppingList
        self.addFoodView = AddFoodView(frame: .zero, foods: FoodManager.shared.foods)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .SZColorPrimaryColor
        addFoodView.collectionView.shoppingList = shoppingList
        addFoodView.collectionView.foodToSelectDelegate = foodToSelectDelegate
        backBtn()
        addFoodBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.addFoodView
    }
}

extension AddFoodController{
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
    
    func addFoodBtn(){
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setTitle("Ok", for: .normal)
        btn.titleLabel?.font = .SZFontTextBold
        btn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
}
