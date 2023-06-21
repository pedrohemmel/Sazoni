//
//  UIViewExtension.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 30/05/23.
//

import Foundation
import UIKit

// MARK: - UIView extension to falicitate the build of a constraints list
extension UIView {
    /// Method to setup a list of constraints to self UIView
    ///
    /// - Parameter activate: Block that provide the constraints list to be activated, that uses self as parameter
    func setupConstraints(_ activate: (UIView) -> [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(activate(self))
    }
    
    func addLeftBorder(color: UIColor, width: CGFloat) {
        let leftBorder = CALayer()
        leftBorder.backgroundColor = color.cgColor
        leftBorder.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        
        self.layer.addSublayer(leftBorder)
    }
    
    func addTopBorder(color: UIColor, height: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.brown.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
        
        self.layer.addSublayer(topBorder)
    }
    
    func removeBottomBorder(borderWidth: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.clear.cgColor
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: 1)
        self.layer.addSublayer(bottomBorder)
    }
}

