import UIKit

class AddFoodView: UIView {
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Adicionar"
        view.font = .SZFontTitle
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var foods: [Food]
    
    
    lazy var collectionView: FoodToSelectCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .SZSizeCellFood
        layout.minimumInteritemSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        let view = FoodToSelectCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(frame: CGRect, foods:[Food]) {
        self.foods = foods
        super.init(frame: frame)
        collectionView.foods = foods
        self.setupViewConfiguration()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddFoodView: ViewCode {
    func buildViewHierarchy() {
        [self.title, collectionView].forEach({addSubview($0)})
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        }
        collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            
        }
    }
    
    func setupAdditionalConfiguration() {
    }
}
