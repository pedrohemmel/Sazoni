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
    
    private var choosenFilters = [FastFilterModel]()
    
    private var fastFilters = [
        FastFilterModel(name: "months", idCategory: nil, filterIsSelected: false),
        FastFilterModel(name: "fruits", idCategory: 0, filterIsSelected: false),
        FastFilterModel(name: "greenstuff", idCategory: 1, filterIsSelected: false),
        FastFilterModel(name: "greens", idCategory: 2, filterIsSelected: false),
        FastFilterModel(name: "fished", idCategory: 3, filterIsSelected: false)
    ]
    
    //MARK: - Views
    var fastFilterComponent: FastFilterComponent = {
        let fastFilterComponent = FastFilterComponent(frame: .zero)
        fastFilterComponent.translatesAutoresizingMaskIntoConstraints = false
        return fastFilterComponent
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
        self.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
}

extension ExampleSecondaryViewController: FastFilterDelegate {
    func didClickCategoryFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.append(FastFilterModel(name: fastFilter.name, idCategory: fastFilter.idCategory, filterIsSelected: nil))
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = true
        self.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    func didClickMonthFilter() {
        let newVC = MonthSelectionViewController()
        newVC.fastFilterDelegate = self
        newVC.sheetPresentationController?.detents = [.medium()]
        self.present(newVC, animated: true)
    }
    func didSelectMonthFilter(monthName: String) {
        self.deleteMonthIfItExists()
        self.choosenFilters.append(FastFilterModel(name: monthName, idCategory: nil, filterIsSelected: nil))
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == "months" }) ?? 0].filterIsSelected = true
        self.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
    }
    func didDeleteFilter(fastFilter: FastFilterModel) {
        self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0)
        self.fastFilters[self.fastFilters.firstIndex(where: { $0.name == fastFilter.name }) ?? 0].filterIsSelected = false
        self.fastFilterComponent.filterCollectionView.setup(fastFilterDelegate: self, fastFilters: self.fastFilters)
        self.fastFilterComponent.filterSelectedCollectionView.setup(fastFilterDelegate: self, choosenFilters: self.choosenFilters)
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

//MARK: - Functions here
extension ExampleSecondaryViewController {
    func deleteMonthIfItExists() {
        let months = [
            "Janeiro",
            "Fevereiro",
            "Março",
            "Abril",
            "Maio",
            "Junho",
            "Julho",
            "Agosto",
            "Setembro",
            "Outubro",
            "Novembro",
            "Dezembro"
        ]
        
        for month in months {
            if self.choosenFilters.contains(where: { $0.name == month }) {
                self.choosenFilters.remove(at: self.choosenFilters.firstIndex(where: { $0.name == month }) ?? 0)
            }
        }
    }
}
