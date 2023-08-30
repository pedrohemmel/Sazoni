//
//  FastFilter.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 28/08/23.
//

import Foundation

struct FastFilter {
    static let fastFilters: [FastFilterModel] = [
        FastFilterModel(name: "months", idCategory: nil, filterIsSelected: false),
        FastFilterModel(name: "Frutas", idCategory: 0, filterIsSelected: false),
        FastFilterModel(name: "Legumes", idCategory: 1, filterIsSelected: false),
        FastFilterModel(name: "Verduras", idCategory: 2, filterIsSelected: false),
        FastFilterModel(name: "Pescados", idCategory: 3, filterIsSelected: false)
    ]
    static let fastFiltersFavorite: [FastFilterModel] = [
        FastFilterModel(name: "Frutas", idCategory: 0, filterIsSelected: false),
        FastFilterModel(name: "Legumes", idCategory: 1, filterIsSelected: false),
        FastFilterModel(name: "Verduras", idCategory: 2, filterIsSelected: false),
        FastFilterModel(name: "Pescados", idCategory: 3, filterIsSelected: false)
    ]
}
