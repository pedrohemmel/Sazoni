//
//  ShoppingListManager.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 04/09/23.
//

import Foundation

class ShoppingListManager {
    var shoppingLists = [ShoppingListModel]()
    var filteredShoppingLists = [ShoppingListModel]()
    let defaultKey = "boughtList"
    
    static let shared = ShoppingListManager()
    
    func searchShoppingLists(with searchText: String) {
        filteredShoppingLists = shoppingLists
        if searchText != "" {
            filteredShoppingLists = filteredShoppingLists.filter { ($0.name ?? "Sem Título").lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func orderShoppingLists(by orderType: Int) {
        switch orderType {
        case 0:
            print("Alfabética crescente")
        case 1:
            print("Alfabética crescente")
        default:
            print("Não identificado")
        }
    }
}

extension ShoppingListManager {
    func getAllBoughtList(_ key: String, response: @escaping (() -> Void)) {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                shoppingLists = try decoder.decode([ShoppingListModel].self, from: boughtList)
                filteredShoppingLists = shoppingLists
                response()
            } catch {
                print("Couldn't not save the updated boughtList.")
            }
        }
    }
    
    func createNewBoughtList(_ key: String, name: String?) {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                
                let decoder = JSONDecoder()
                var newBoughtList = try decoder.decode([ShoppingListModel].self, from: boughtList)
                newBoughtList.append(ShoppingListModel(
                    id: newBoughtList.count,
                    name: name ?? "Sem título",
                    itemShoppingListModel: [ItemShoppingListModel](),
                    isClosed: false))
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't not save the updated boughtList.")
            }
        } else {
            do {
                let newBoughtList = [ShoppingListModel(id: 0, itemShoppingListModel: [ItemShoppingListModel](), isClosed: false)]
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't not save boughtList.")
            }
        }
        
       
    }
    
    private func boughtListAction(_ key: String, idBoughtList: Int?, idItem: Int?, action: @escaping ((_ idBoughtList: Int?, _ idItem: Int?, _ boughtList: [ShoppingListModel]) -> [ShoppingListModel])) {
        if let boughtList = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                var newBoughtList = try decoder.decode([ShoppingListModel].self, from: boughtList)
                
                newBoughtList = action(idBoughtList, idItem, newBoughtList)
                
                let encoder = JSONEncoder()
                let data = try encoder.encode(newBoughtList)
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print("Couldn't do this issue")
            }
        }
    }
    
    func deleteBoughtList(_ key: String, idBoughtList: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: nil) { idBoughtList, _, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            var newBoughtList = boughtList
            if let index = newBoughtList.firstIndex(where: { $0.id == idBoughtList }) {
                newBoughtList[index].itemShoppingListModel.removeAll()
                newBoughtList.remove(at: index)
            } else {
                print("Could not find boughtList to delete.")
            }
            
            return newBoughtList
        }
    }
    
    func deleteAllBoughtList(_ key: String) {
        self.boughtListAction(key, idBoughtList: nil, idItem: nil) { _, _, boughtList in
            var newBoughtList = boughtList
            if newBoughtList.count > 0 {
                for i in 0...(newBoughtList.count - 1) {
                    newBoughtList[i].itemShoppingListModel.removeAll()
                }
            }
            newBoughtList.removeAll()
            
            return newBoughtList
        }
    }
    
    func changeBoughtListName(_ key: String, idBoughtList: Int, newName: String?) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: nil) { idBoughtList, _, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            var newBoughtList = boughtList
            
            if let newName {
                newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].name = newName
            } else {
                newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].name = "Sem título"
            }
            
            return newBoughtList
        }
    }
    
    func changeItemBoughtListStatus(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            let itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel[itemsShoppingListModel.firstIndex(where: { $0.id == idItem }) ?? 0].isBought.toggle()
            
            return newBoughtList
        }
    }
    
    func addNewItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel.append(ItemShoppingListModel(id: idItem, isBought: false))
            
            return newBoughtList
        }
    }
    
    func removeItemBoughtList(_ key: String, idBoughtList: Int, idItem: Int) {
        self.boughtListAction(key, idBoughtList: idBoughtList, idItem: idItem) { idBoughtList, idItem, boughtList in
            guard let idBoughtList = idBoughtList else { return boughtList }
            guard let idItem = idItem else { return boughtList }
            var newBoughtList = boughtList
            let itemsShoppingListModel = newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel
            newBoughtList[newBoughtList.firstIndex(where: { $0.id == idBoughtList }) ?? 0].itemShoppingListModel.remove(at: itemsShoppingListModel.firstIndex(where: { $0.id == idItem }) ?? 0)
            
            return newBoughtList
        }
    }
}
