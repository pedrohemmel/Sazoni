

import UIKit

class FavoriteFoodView: UIView {

    lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Favoritos"
        view.font = UIFont.systemFont(ofSize: 64, weight: .semibold)
        view.textColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fastFilterComponent: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    
    lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 105, height: 140)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionViewInstance = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionViewInstance
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FavoriteFoodView: ViewCode {
    
    func buildViewHierarchy() {
        [self.title, self.fastFilterComponent, self.collectionView].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.fastFilterComponent.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)

            ]
        }
        
        self.fastFilterComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -10)
            ]
        }
        
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.fastFilterComponent.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = UIColor(red: 1, green: 0.98, blue: 0.867, alpha: 1)
    }
}
