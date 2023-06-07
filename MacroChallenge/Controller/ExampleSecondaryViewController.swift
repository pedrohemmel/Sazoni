//
//  ExampleSecondaryViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

protocol OpenSheetDelegate: AnyObject {
    func didClickCell()
}

class ExampleSecondaryViewController: UIViewController {
    
    var fastFilterComponent: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
        self.fastFilterComponent.filterCollectionView.setup(openSheetDelegate: self)
    }
}

extension ExampleSecondaryViewController: OpenSheetDelegate {
    func didClickCell() {
//        let newVC =
        print("OI")
    }
}

extension ExampleSecondaryViewController: ViewCode {
    func buildViewHierarchy() {
        [self.fastFilterComponent].forEach({self.view.addSubview($0)})
    }
    
    func setupConstraints() {
        self.fastFilterComponent.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                view.heightAnchor.constraint(equalToConstant: 100)
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.view.backgroundColor = .blue
    }
}
