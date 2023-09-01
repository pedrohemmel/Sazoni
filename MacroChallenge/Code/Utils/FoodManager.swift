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
    
    func fetchFoods() -> Future<[Food], Error> {
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
