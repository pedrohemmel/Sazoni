
import UIKit

class DetailSheetViewController: UIViewController {
    
    private var sheetView = DetailSheetView()
    private var food: Food
    
    init(_ food: Food) {
        self.food = food
        sheetView.setFood(self.food)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = sheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
