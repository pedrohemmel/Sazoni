import Foundation

struct Food: Codable{
    let id_food: Int
    let name_food: String
    let image_source_food: String
    let is_favorite_food: Bool
    let category_food: Category
    let seasonalities: [Seasonality]
}
