

import XCTest
//import UIKit
@testable import MacroChallenge

final class FavoriteTests: XCTestCase {
    
    let btnSaveFavoriteFood = TitleDetailView()
    let userDefaults = UserDefaults.standard
    let key = "favotiteTest"
    
    let foods: [Food] = [
        Food(id_food: 0, name_food: "Banana", image_source_food: "", is_favorite_food: false, category_food: Category(id_category: 0, name_category: ""), seasonalities: [Seasonality]()),
        Food(id_food: 1, name_food: "Melancia", image_source_food: "", is_favorite_food: false, category_food: Category(id_category: 0, name_category: ""), seasonalities: [Seasonality]()),
        Food(id_food: 2, name_food: "Laranja", image_source_food: "", is_favorite_food: false, category_food: Category(id_category: 0, name_category: ""), seasonalities: [Seasonality]())
    ]
    
    func saveFavoriteFood(idFood: Int){
        if let data = userDefaults.array(forKey: key){
            var newData = data
            newData.append(idFood)
            userDefaults.set(newData, forKey: key)
        } else {
            userDefaults.set([idFood], forKey: key)
        }
    }
    
    func testFavoriteSave(){
        self.btnSaveFavoriteFood.saveItem(id: foods[0].id_food, key)
        if let data = userDefaults.array(forKey: key) as? [Int]{
            var foundSavedItem = self.checkItemArray(foods[0].id_food, data)
            XCTAssert(foundSavedItem == true)
            var newData = data
            newData.removeLast()
            UserDefaults.standard.set(newData, forKey: key)
        }
        if let data = userDefaults.array(forKey: key) as? [Int]{
            var foundSavedItem = self.checkItemArray(foods[0].id_food, data)
            XCTAssert(foundSavedItem == false )
        }
    }
    
    func checkItemArray(_ idFood: Int,_ data: [Int]) -> Bool{
        for i in data{
            if i == idFood{
                return true
            }
        }
        return false
    }

}
