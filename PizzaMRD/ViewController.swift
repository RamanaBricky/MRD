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
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = CategoriesVM()
        categoriesCollectionView.register(UINib.init(nibName: String(describing: CategoriesCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoriesCell.self))
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.navigateToSubCategory), name: NSNotification.Name(rawValue:"NavigateToSubCategory"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToSubCategory(notification: Notification){
        
        let subCategoryVC = notification.object as! SubCategoryVC
        self.navigationController?.pushViewController(subCategoryVC, animated: true)
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.categoriesList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indextPath: IndexPath) -> UICollectionViewCell {
        let buttonTitle = (viewModel?.categoriesList[(indextPath as NSIndexPath).item+1])! as String
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indextPath) as! CategoriesCell

            cell.categoryID = (indextPath as NSIndexPath).row + 1
            cell.categoryButton.setTitle(buttonTitle, for: .normal)
        return cell
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            if UIScreen.main.bounds.size.width > 1024 {
                return CGSize.init(width: 340.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 330.0, height: 100.0)
            }
        }
        else{
            if UIScreen.main.bounds.size.width > 768 {
                return CGSize.init(width: 256.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 340.0, height: 100.0)
            }
        }
    }
    
//    func collectionView(_ colle)
}

extension ViewController: UICollectionViewDelegate {
    
}
