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
}

