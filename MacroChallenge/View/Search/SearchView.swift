

import UIKit

class SearchView: UIView {
    
    lazy var search: SearchBarComponent = {
        let view = SearchBarComponent()
        view.placeholder = "Digite sua pesquisa"
//        view.barStyle = .default
        view.barTintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var gridFood: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 105, height: 140)

        let collectionViewInstance = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
        collectionViewInstance.backgroundColor = UIColor.white
        collectionViewInstance.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        collectionViewInstance.delegate = collectionViewInstance
        collectionViewInstance.dataSource = collectionViewInstance

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

extension SearchView: ViewCode{
    func buildViewHierarchy() {
        self.addSubview(search)
        self.addSubview(gridFood)
    }
    
    func setupConstraints() {
        search.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: gridFood.topAnchor)
            ]}
        
        gridFood.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: search.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -90)
            ]}
        
        
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}
