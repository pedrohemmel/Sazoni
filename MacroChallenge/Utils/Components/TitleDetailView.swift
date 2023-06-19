

import UIKit

class TitleDetailView: UIView {
    
    private let userDefaults = UserDefaults.standard
    private let keyUserDefaults = "test"

    private lazy var titleFood: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        title.textColor = UIColor(named: "TextColor")
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.329, green: 0.204, blue: 0.09, alpha: 1)
        line.layer.cornerRadius = 3
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private lazy var buttonToFavorite: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.addFavoriteFood), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleDetailView: ViewCode{
    func buildViewHierarchy() {
        [self.titleFood, self.line].forEach({self.buttonToFavorite.addSubview($0)})
        self.addSubview(self.buttonToFavorite)
    }
    
    func setupConstraints() {
        self.titleFood.setupConstraints{ view in
            [
                view.bottomAnchor.constraint(equalTo: self.line.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.buttonToFavorite.leadingAnchor, constant: -20),
                view.heightAnchor.constraint(equalToConstant: 40)
                
            ]}
        
        self.buttonToFavorite.setupConstraints { view in
            [
                view.bottomAnchor.constraint(equalTo: self.line.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.titleFood.trailingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.heightAnchor.constraint(equalToConstant: 40),
                view.widthAnchor.constraint(equalToConstant: 40)

            ]
        }
        
        self.line.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.titleFood.bottomAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -30),
                view.heightAnchor.constraint(equalToConstant: 4)
        
            ]}
        
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}


//MARK: Functions
extension TitleDetailView{
    
    func setNameFood(_ nameFood: String){
        self.titleFood.text = nameFood
    }
    
    @objc private func addFavoriteFood() {
        let foodID = buttonToFavorite.tag
        
        if var listFavoriteFood = userDefaults.array(forKey: keyUserDefaults) as? [Int] {
            let isActive = checkFavoriteFood(id: foodID)
            
            if !isActive {
                saveItem(id: foodID, keyUserDefaults)
                buttonToFavorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                if let index = listFavoriteFood.firstIndex(of: foodID) {
                    listFavoriteFood.remove(at: index)
                    userDefaults.set(listFavoriteFood, forKey: keyUserDefaults)
                }
                buttonToFavorite.setImage(UIImage(systemName: "star"), for: .normal)
            }
            buttonToFavorite.tintColor = UIColor(named: "TextColor")
        }
    }

    
    private func checkFavoriteFood(id: Int) -> Bool {
        if let favoriteFood = userDefaults.array(forKey: keyUserDefaults) as? [Int]{
            for favorite in favoriteFood {
                if favorite == id {
                    return true
                }
            }
        }
        return false
    }
    
    func saveItem(id: Int,_ keyUserDefaults: String){
        if let listFavoriteFood = userDefaults.array(forKey: keyUserDefaults){
            var newList = listFavoriteFood
            newList.append(id)
            userDefaults.set(newList, forKey: keyUserDefaults)
        } else {
            userDefaults.set([id], forKey: keyUserDefaults)
        }
    }
    
    private func setImageButton(_ isActive: Bool) -> String {
        if isActive{
            return "star.fill"
        }else{
            return "star"
        }
    }
    
    func setButton(id: Int){
        self.buttonToFavorite.tag = id
        self.buttonToFavorite.setImage(UIImage(systemName: setImageButton(checkFavoriteFood(id: id))), for: .normal)
        self.buttonToFavorite.tintColor = UIColor(named: "TextColor")
    }
    
}
