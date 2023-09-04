

import UIKit

class FavoriteFoodView: UIView {

    private lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Favoritos"
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
    
    lazy var collectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .SZSizeCellFood
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 40, left: 8, bottom: 32, right: 8)
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
                view.bottomAnchor.constraint(equalTo: self.fastFilterComponent.topAnchor, constant: -16),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
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
        self.backgroundColor = .SZColorPrimaryColor
    }
}
