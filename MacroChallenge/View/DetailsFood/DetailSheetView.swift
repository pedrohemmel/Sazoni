

import UIKit

class DetailSheetView: UIView{
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    
    private lazy var imageFood: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: UIScreen.main.bounds.width * 0.55, y: 0, width: screenWidth * 0.35, height: screenHeight * 0.35)
        image.layer.shadowColor = UIColor.gray.cgColor
        image.layer.shadowRadius = 3.0
        image.layer.shadowOpacity = 1.0
        image.contentMode = .scaleAspectFill
        image.layer.shadowOffset = CGSize(width: 6, height: 4)
        image.layer.masksToBounds = false
        return image
    }()
    
    var titleFood: TitleDetailView = {
        let text = TitleDetailView()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    private lazy var subTitle: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(named: "TextColor")
        title.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Período sazonal"
        return title
    }()
    
    private lazy var collectionView: SeasonalityUICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 80, height: 91)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 12
        
        let collectionSeasonality = SeasonalityUICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionSeasonality.translatesAutoresizingMaskIntoConstraints = false
        return collectionSeasonality
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DetailSheetView: ViewCode{
    func buildViewHierarchy() {
        [self.imageFood, self.titleFood, self.subTitle, self.collectionView].forEach({self.addSubview($0)})
    }
    
    func setupConstraints() {
        self.imageFood.setupConstraints{ view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: (self.bounds.height * 0.05)),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: titleFood.topAnchor, constant: -50),
            ]}
        
        self.titleFood.setupConstraints{ view in
            [
                view.topAnchor.constraint(equalTo: self.imageFood.bottomAnchor, constant: 50),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: self.subTitle.topAnchor, constant: -10),
                view.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        self.subTitle.setupConstraints{ view in
            [
                view.topAnchor.constraint(equalTo: self.titleFood.bottomAnchor, constant: 40),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
                view.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -17),
                
            ]}
        self.collectionView.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.subTitle.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -52),
            ]
        }
        
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = UIColor(named: "Background")
    }
    
    
}

extension DetailSheetView{
    func setFood(_ food: Food){
        let image = UIImage(named: food.image_source_food)!
        self.imageFood.image = image
        self.titleFood.setNameFood(food.name_food)
        self.collectionView.food = food
        self.titleFood.setButton(id: food.id_food)
    }
}

