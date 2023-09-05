import UIKit

class AddFoodController: UIViewController{
    
    private var addFoodView: AddFoodView
    private var foods: [Food]
    
    init(foods: [Food]) {
        self.foods = foods
        self.addFoodView = AddFoodView(frame: .zero, foods: self.foods)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .SZColorPrimaryColor
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    func addFoodBtn(){
        let btn = UIButton(type: .system)
        btn.tintColor = .SZColorBeige
        btn.setTitle("Ok", for: .normal)
        btn.titleLabel?.font = .SZFontTextBold
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    
}
