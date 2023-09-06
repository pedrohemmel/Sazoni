import Foundation
import Combine

class FoodManager{
    private var observer: AnyCancellable?
    
    var foods: [Food] = [Food]()
    var filteredFoods: [Food] = [Food]()
    var favoriteFoods: [Food] = [Food]()
    
    static let shared = FoodManager()
    
    func getFavoriteFoods() {
        self.favoriteFoods = self.foods.filter({ FavoriteList.shared.getListOfFoods().contains($0.id_food) })
    }
}

//Getting foods
extension FoodManager {
    func getFoods(response: @escaping(() -> Void)) {
        self.observer = self.fetchFoods()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.getFavoriteFoods()
                    response()
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { value in
                self.foods = value
                self.filteredFoods = value
            })
    }
    
    private func fetchFoods() -> Future<[Food], Error> {
        return Future { promixe in
            if let filePath = Bundle.main.path(forResource: "data", ofType: "json") {
                do
                    {
                        guard let contents = try String(contentsOfFile: filePath).data(using: .utf8) else { return}
                        let jsonDecoder = JSONDecoder()
                        let formattedData = try jsonDecoder.decode([Food].self, from: contents)
                        DispatchQueue.main.async {
                            promixe(.success(formattedData))
                        }
                    }
                    catch
                    {
                        print("Contents could not be loaded.")
                    }
            } else {
                print("file not find")
            }
        }
    }
}

//Manipulating foods
extension FoodManager {
    func filterFoods(with searchText: String, choosenFilters: [FastFilterModel], byCategory: Category?, currentMonthNumber: Int, monthSelected: String) {
        filteredFoods = foods
        
        if !searchText.isEmpty {
            filteredFoods = filteredFoods.filter { $0.name_food.lowercased().contains(searchText.lowercased()) ||
                $0.seasonalities[currentMonthNumber].state_seasonality.lowercased().contains(searchText.lowercased()) ||
                $0.category_food.name_category.lowercased().contains(searchText.lowercased())
            }
        }
        
        if let byCategory {
            filteredFoods = filteredFoods.filter({ food in
                return food.category_food.id_category == byCategory.id_category
            })
        } else {
            for filter in choosenFilters {
                if !self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                    filteredFoods = filteredFoods.filter({ food in
                        choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                    })
                }
            }
        }
        filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: filteredFoods, currentMonth: monthSelected)
    }
    
    func filterFavoriteFoods(choosenFilters: [FastFilterModel], monthSelected: String) {
        getFavoriteFoods()
        filteredFoods = favoriteFoods
        
        for filter in choosenFilters {
            if !self.verifyIfFilterIsMonth(nameOfFilter: filter.name) {
                filteredFoods = filteredFoods.filter({ food in
                    choosenFilters.contains(where: {$0.idCategory == food.category_food.id_category})
                })
            }
        }
        filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: filteredFoods, currentMonth: monthSelected)
    }
    
    func filterShoppingFoods(itemsShoppingListModel: [ItemShoppingListModel]) {
        filteredFoods = foods
        filteredFoods = filteredFoods.filter({ food in
            return itemsShoppingListModel.contains(where: { $0.id == food.id_food })
        })
        print(getCurrentMonth())
        filteredFoods = orderFoodsByHighQualityInCurrentMonth(foods: filteredFoods, currentMonth: getCurrentMonth())
    }
    
    private func orderFoodsByHighQualityInCurrentMonth(foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Alta", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Média", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Baixa", foods: foods, currentMonth: currentMonth))
        newFoods.append(contentsOf: self.getFoodsInCurrentMonthWithState(state: "Muito baixa", foods: foods, currentMonth: currentMonth))
        return newFoods
    }
    
    private func getFoodsInCurrentMonthWithState(state: String, foods: [Food], currentMonth: String) -> [Food] {
        var newFoods = [Food]()
        for food in foods {
            for seasonality in food.seasonalities {
                if seasonality.month_name_seasonality.lowercased() == currentMonth.lowercased() {
                    if seasonality.state_seasonality.lowercased() == state.lowercased() {
                        newFoods.append(food)
                    }
                }
            }
        }
        newFoods = newFoods.sorted(by: { $0.name_food < $1.name_food })
        return newFoods
        
    }
    
    private func verifyIfFilterIsMonth(nameOfFilter: String) -> Bool {
        let months = Months.monthArray
        return months.contains(nameOfFilter)
    }
}

extension FoodManager {
    func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth.capitalized
    }
}
