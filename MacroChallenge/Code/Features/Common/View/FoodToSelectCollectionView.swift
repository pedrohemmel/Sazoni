

import UIKit
 

class FoodToSelectCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout{
    
    weak var foodToSelectDelegate: FoodToSelectDelegate? = nil
    var shoppingList: ShoppingListModel?
    var foods: [Food] = [Food]() {
        didSet {
            self.reloadData()
        }
    }
    private let spacing:CGFloat = 16.0
    
    var isShoppingList = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(SelectionCellView.self, forCellWithReuseIdentifier: "SelectionCellView")
        self.delegate = self
        self.dataSource = self
        self.backgroundView = .none
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FoodToSelectCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCellView", for: indexPath) as! SelectionCellView
        let currentStateSeasonality = self.foods[indexPath.row].seasonalities[self.foods[indexPath.row].seasonalities.firstIndex(where: { $0.month_name_seasonality == FoodManager.shared.getCurrentMonth() }) ?? 0].state_seasonality
        
        cell.sazonality.image = UIImage.getImageSazonality(currentStateSeasonality)
        cell.foodImage.image = UIImage(named: "\(self.foods[indexPath.row].image_source_food)")
        cell.nameFood.text = foods[indexPath.row].name_food
        cell.backgroundColor = .SZColorBeige
        cell.layer.cornerRadius = .SZCornerRadiusMediumShape
        
        if let shoppingList {
            cell.btnSelect.tag = indexPath.row
            cell.isUserInteractionEnabled = true
            cell.btnSelect.addTarget(self, action: #selector(addOrRemoveItem), for: .touchUpInside)
            if !isShoppingList {
                if ShoppingListManager.shared.verifyIfFoodIsInList(food: foods[indexPath.row], shoppingList: shoppingList) {
                    cell.btnSelect.setImage(UIImage(named: "SZ.checkmark.circle.fill"), for: .normal)
                } else {
                    cell.btnSelect.setImage(UIImage(named: "SZ.checkmark.circle"), for: .normal)
                    
                }
            } else {
                cell.btnSelect.setImage(UIImage(named: "button_delete"), for: .normal)
            }
        }
        
        return cell
    }
    
    
}

extension FoodToSelectCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("OI")
    }
}


extension FoodToSelectCollectionView {
    
    @objc func addOrRemoveItem(button: UIButton) {
        if let shoppingList {
            if ShoppingListManager.shared.verifyIfFoodIsInList(food: foods[button.tag], shoppingList: shoppingList) {
                ShoppingListManager.shared.removeItemBoughtList(ShoppingListManager.shared.defaultKey, idBoughtList: shoppingList.id, idItem: foods[button.tag].id_food)
                foodToSelectDelegate?.didUpdateShoppingList(shoppingList: shoppingList, food: foods[button.tag])
            } else {
                ShoppingListManager.shared.addNewItemBoughtList(ShoppingListManager.shared.defaultKey, idBoughtList: shoppingList.id, idItem: foods[button.tag].id_food)
                
                foodToSelectDelegate?.didUpdateShoppingList(shoppingList: shoppingList, food: foods[button.tag])
            }
            
            ShoppingListManager.shared.getAllBoughtList(ShoppingListManager.shared.defaultKey) {
                let shoppingLists = ShoppingListManager.shared.filteredShoppingLists
                if let shoppingList = self.shoppingList {
                    self.shoppingList = shoppingLists[shoppingLists.firstIndex(where: {$0.id == shoppingList.id}) ?? 0]
                }
                self.reloadData()
            }
        }
    }
}
