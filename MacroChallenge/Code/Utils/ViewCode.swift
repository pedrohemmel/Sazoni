//
//  ViewCode.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation

protocol ViewCode {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupViewConfiguration()
}

extension ViewCode {
    func setupViewConfiguration() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
