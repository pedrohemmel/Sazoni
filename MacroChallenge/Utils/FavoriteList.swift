

import UIKit

class FavoriteList{
    
    static let shared = FavoriteList()
    private var observers: [FavoritesObserver] = []
    private let userDefaults = UserDefaults.standard
    private let keyUserDefaults = "favorite"
    
}

extension FavoriteList {
    
    func addFavoriteFood(_ buttonToFavorite: UIButton) {
        let foodID = buttonToFavorite.tag
        let isActive = checkFavoriteFood(id: foodID)
        if !isActive {
            saveItem(id: foodID, keyUserDefaults)
            buttonToFavorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            if var listFavoriteFood = userDefaults.array(forKey: keyUserDefaults) as? [Int] {
                if let index = listFavoriteFood.firstIndex(of: foodID) {
                    listFavoriteFood.remove(at: index)
                    userDefaults.set(listFavoriteFood, forKey: keyUserDefaults)
                }
                buttonToFavorite.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        notifyObservers()
        buttonToFavorite.tintColor = UIColor(named: "TextColor")
    }
    
    func getListOfFoods() -> [Int] {
        if let favoriteFood = userDefaults.array(forKey: keyUserDefaults) as? [Int]{
            return favoriteFood
        }
        return [Int]()
    }

    
    func checkFavoriteFood(id: Int) -> Bool {
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
    
    func setImageButton(_ isActive: Bool) -> String {
        if isActive{
            return "star.fill"
        }else{
            return "star"
        }
    }
    
}

extension FavoriteList {
    
    func registerObserver(_ observer: FavoritesObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: FavoritesObserver) {
        observers.removeAll { $0 === observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.favoriteListDidUpdate()
        }
    }
}
