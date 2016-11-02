//
//  SubCategoryVC.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import UIKit
import Foundation

class SubCategoryVC: UIViewController, SubCategoryViewModelDelegate {
    
    @IBOutlet weak var subCategoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesTitleLabel: UILabel!
    
    var viewModel:SubCategoryViewModel? {
        didSet{
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let coreDataStack = CoreDataStack()
        
        subCategoriesTitleLabel.text = coreDataStack.categoriesList[(viewModel?.selectedCategoryID)!]
        
        subCategoriesCollectionView.register(UINib.init(nibName: String(describing: SubCategoryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SubCategoryCell.self))
        NotificationCenter.default.addObserver(self, selector: #selector(SubCategoryVC.subCategorySelected), name: NSNotification.Name(rawValue:"SubCategorySelected"), object: nil)
        
    }
    
    func subCategorySelected(notification: Notification){
        
        
         let subCategoryOptionsDict = notification.userInfo
         let mrdDetailsVM = MRDetailsVM()
        mrdDetailsVM.selectedCategoryID = subCategoryOptionsDict!["cat"] as! Int
        mrdDetailsVM.selectedSubCategoryID = subCategoryOptionsDict!["sub"] as! Int
        let mrdDetailsVC = MRDDetailsVC()
        mrdDetailsVC.viewModel = mrdDetailsVM
         self.navigationController?.pushViewController(mrdDetailsVC, animated: true)
        
//        let subCategoryOptions = SubCategoryOptions.init(catID: subCategoryOptionsDict!["cat"] as! Int, subCatID: subCategoryOptionsDict!["sub"] as! Int)
//        subCategoryOptions.delegate = self
//        
////        let startCenter = cell.contentView.convert(startCenter, to: self.window)
////        
////        let endCenter   = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
////        overView.center = startCenter
////        overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//        
//        AlertWindowView.sharedInstance.showWithView(subCategoryOptions,
//                                                      animations:
//            {
//                UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut,
//                               animations: {
//                                subCategoryOptions.transform = CGAffineTransform.identity
////                                subCategoryOptions.center = endCenter
//                    },
//                               completion: {(completed) in
//                })
//            },
//                                                      dismissAnimations:
//            {
//                [weak subCategoryOptions] in
//                UIView.animate(withDuration: 0.3, animations: {
//                    if let overView = subCategoryOptions
//                    {
//                        overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
////                        overView.center = startCenter
//                    }
//                })
//            })
    }
}

extension SubCategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.subCategoryList!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indextPath: IndexPath) -> UICollectionViewCell {
        let buttonTitle = (viewModel?.subCategoryList![(indextPath as NSIndexPath).item+1])! as String
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indextPath) as! SubCategoryCell
        cell.subCategoryID = (indextPath as NSIndexPath).row + 1
        cell.categoryID = viewModel?.selectedCategoryID
        cell.subCategoryButton.setTitle(buttonTitle, for: .normal)
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
}

extension SubCategoryVC: SubCategoryOptionsDelegate {
    
    func didCancel(){
        
    }
    
    func optionSelected(with indexPath: Int){
        
    }
}
