//
//  UIImageExtension.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 01/09/23.
//

import UIKit

extension UIImage {
    static let SZIconApple = UIImage(named: "apple")
    static let SZIconCabbage = UIImage(named: "cabbage")
    static let SZIconCarrot = UIImage(named: "carrot")
    static let SZIconFish = UIImage(named: "fish")
    static let SZSazonalityHeigth = UIImage(named: "IconAlta")
    static let SZSazonalityMedium = UIImage(named: "IconMedia")
    static let SZSazonalityLow = UIImage(named: "IconBaixa")
    static let SZSazonalityVeryLow = UIImage(named: "IconMuitoBaixa")
    static let SZIconHome = UIImage(named: "home")
    static let SZIconHomeFill = UIImage(named: "home.fill")
    static let SZIconFavorite = UIImage(named: "favorite")
    static let SZIconFavoriteFill = UIImage(named: "favorite.fill")
    static let SZIconList = UIImage(named: "list")
    static let SZIconListFill = UIImage(named: "list.fill")
    
    static func getImageSazonality(_ sazonality: String) -> UIImage?{
        print(sazonality)
        switch sazonality{
        case "Alta":
            return self.SZSazonalityHeigth
            
        case "Média":
            return self.SZSazonalityMedium

        case "Muito baixa":
            return self.SZSazonalityVeryLow

        case "Baixa":
            return self.SZSazonalityLow
            
        default:
            return UIImage(named: "error")
        }
    }
    
    static func getImageCategory(_ category: String)->UIImage?{
        switch category{
        case "icon_0":
            return SZIconApple
            
        case "icon_1":
            return SZIconCabbage
            
        case "icon_2":
            return SZIconCarrot
            
        case "icon_3":
            return SZIconFish
        default:
            return UIImage(named: "error")
        }
    }
    
    
}
