//
 //  FoodViewController.swift
 //  MacroChallenge
 //
 //  Created by Bruno Lafayette on 29/05/23.
 //
 import UIKit


 final class FoodViewController: UIViewController {

     var foods = [Food]()
     private var dataIsReceived = false
     lazy private var foodManager = FoodManager(response: {
         self.dataIsReceived = true
         self.setupViewConfiguration()
     })

     private lazy var collectionView: FoodCollectionView = {

         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.itemSize = CGSize(width: 105, height: 162)

         let collectionViewInstance = FoodCollectionView(frame: view.bounds, collectionViewLayout: layout)
         collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
         collectionViewInstance.backgroundColor = UIColor.white
         collectionViewInstance.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
         collectionViewInstance.delegate = collectionViewInstance
         collectionViewInstance.dataSource = collectionViewInstance

         return collectionViewInstance
     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         self.setupViewConfiguration()
     }
 }

 extension FoodViewController: ViewCode{

     func buildViewHierarchy() {
         view.addSubview(collectionView)
     }

     func setupConstraints() {
         NSLayoutConstraint.activate([
             collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
             collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }

     func setupAdditionalConfiguration() {
         
         if !self.dataIsReceived {
             self.foodManager.fetchFood()
         } else {
             self.foods = self.foodManager.foods
             self.collectionView.foods = self.foods
             self.collectionView.reloadData()
         }
     }

 }


 class FoodCollectionView: UICollectionView, UICollectionViewDataSource {
     
     var foods = [Food]()

     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return foods.count
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//         backgroundColor = .cyan
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
         cell.foodImage.image = UIImage(named: "abobrinha_brasileira")
         cell.nameFood.text = foods[indexPath.row].name_food
         cell.sazonality.text = foods[indexPath.row].seasonalities[2].state_seasonality + " disponibilidade"
         
         cell.container.backgroundColor = UIColor(named: foods[indexPath.row]
                                                            .seasonalities[2]
                                                            .state_seasonality)
         cell.layer.cornerRadius = 20
         cell.container.layer.borderColor = UIColor(named: "Border"+foods[indexPath.row]
                                                                        .seasonalities[2]
                                                                        .state_seasonality)?.cgColor
         
         cell.backgroundColor = .cyan
         return cell
     }

 }


extension FoodCollectionView: UICollectionViewDelegate{
    
}
