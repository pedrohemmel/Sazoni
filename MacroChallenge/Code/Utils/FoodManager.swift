import Foundation
import Combine

class FoodManager{
    var foods: [Food] = [Food]()
    var response: (() -> Void)
    
    init() {
        self.response = {
            print("Response")
        }
    }
     
    init(response: @escaping (() -> Void)){
        self.response = response
        
    }
    
    func fetchFood(){
        if let filePath = Bundle.main.path(forResource: "data", ofType: "json") {
            do
                {
                    guard let contents = try String(contentsOfFile: filePath).data(using: .utf8) else { return}
                    let jsonDecoder = JSONDecoder()
                    let formattedData = try jsonDecoder.decode([Food].self, from: contents)
                    DispatchQueue.main.async {
                        self.foods = formattedData
                        self.response()
                    }
                }
                catch
                {
                    print("Contents could not be loaded.")
                }
        }
        else{
            print("file not find")
        }
        
    }
    
    static let shared = FoodManager()
    
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
