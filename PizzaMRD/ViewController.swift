//
//  ViewController.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 29/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, CategoriesViewModelDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var viewModel:CategoriesViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = CategoriesVM()
        categoriesCollectionView.register(UINib.init(nibName: String(describing: CategoriesCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoriesCell.self))
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.navigateToSubCategory), name: NSNotification.Name(rawValue:"NavigateToSubCategory"), object: nil)
        
        title = "MRD"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToSubCategory(notification: Notification){
        
        let subCategoryVC = notification.object as! SubCategoryVC
        self.navigationController?.pushViewController(subCategoryVC, animated: true)
        
    }
    
    func configureUI() {
        view.backgroundColor = Config.shared.viewBackgroundColor
        categoriesCollectionView.backgroundColor = Config.shared.viewBackgroundColor
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.categoriesList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = DataStack.nextAvailableIndex(viewModel!.categoriesList, at: indexPath.row)
        let buttonTitle = (viewModel?.categoriesList[index])! as String
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell

            cell.categoryID = index
            cell.categoryButton.setTitle(buttonTitle, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(30.0, 10.0, 10.0, 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 30.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            if UIScreen.main.bounds.size.width >= 1024 {
                return CGSize.init(width: 320.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 330.0, height: 100.0)
            }
        }
        else{
            if UIScreen.main.bounds.size.width >= 768 {
                return CGSize.init(width: 360.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 170.0, height: 90.0)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        categoriesCollectionView.reloadData()
        coordinator.animate(alongsideTransition: {
            context in
            self.categoriesCollectionView.collectionViewLayout.invalidateLayout()
            self.categoriesCollectionView.performBatchUpdates({
                self.categoriesCollectionView.setCollectionViewLayout(self.categoriesCollectionView.collectionViewLayout, animated: true)
            })
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
