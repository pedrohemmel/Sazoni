//
 //  FoodViewController.swift
 //  MacroChallenge
 //
 //  Created by Bruno Lafayette on 29/05/23.
 //
 import UIKit


 final class FoodViewController: UIViewController {
     private lazy var collectionView: FoodCollectionView = {

         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .vertical
         layout.itemSize = CGSize(width: 100, height: 132)
         layout.minimumInteritemSpacing = 20
         layout.minimumLineSpacing = 20

         let collectionViewInstance = FoodCollectionView(frame: view.bounds, collectionViewLayout: layout)
         collectionViewInstance.translatesAutoresizingMaskIntoConstraints = false
         collectionViewInstance.backgroundColor = UIColor.white
         collectionViewInstance.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
         collectionViewInstance.delegate = collectionViewInstance
         collectionViewInstance.dataSource = collectionViewInstance

         return collectionViewInstance
     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         self.setupViewConfiguration()
     }
 }

 extension FoodViewController: ViewCode {
     func buildViewHierarchy() {
         view.addSubview(collectionView)
     }

     func setupConstraints() {
         NSLayoutConstraint.activate([
             collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
     }

     func setupAdditionalConfiguration() {
     }
 }


 class FoodCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 30
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
         cell.backgroundColor = UIColor.lightGray
         cell.layer.cornerRadius = 10
         return cell
     }
 }
