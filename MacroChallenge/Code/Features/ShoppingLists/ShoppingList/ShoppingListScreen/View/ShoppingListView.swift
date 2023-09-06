import UIKit

class ShoppingListView: UIView{
    
    weak var addFoodDelegate: AddFoodDelegate? = nil
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = .SZFontTitle
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fastFilterComponent: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    
    lazy var collectionView: FoodToSelectCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .SZSizeCellFood
        layout.minimumInteritemSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        let view = FoodToSelectCollectionView(frame: .zero, collectionViewLayout: layout)
        view.isShoppingList = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonToAddFoods: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .SZColorBeige
        button.backgroundColor = .SZColorSecundaryColor
        button.addTarget(self, action: #selector(buttonAddAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShoppingListView: ViewCode {
    func buildViewHierarchy() {
        [self.title, fastFilterComponent, collectionView, buttonToAddFoods].forEach({addSubview($0)})
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: self.fastFilterComponent.topAnchor)
            ]
        }
        self.fastFilterComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.midX * 0.4),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.midX * 0.4),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor),
            ]
        }
        collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.fastFilterComponent.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            
        }
        buttonToAddFoods.setupConstraints { view in
            [
                view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.widthAnchor.constraint(equalToConstant: 50),
                view.heightAnchor.constraint(equalToConstant: 50)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        buttonToAddFoods.layer.cornerRadius = 25
    }
}

extension ShoppingListView {
    @objc func buttonAddAction() {
        addFoodDelegate?.didClickAddNewFood()
    }
}
