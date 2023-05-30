import Foundation
import UIKit



class FoodManager{
    var foods: [Food] = [Food]()
    var response: (() -> Void)
     
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
}
