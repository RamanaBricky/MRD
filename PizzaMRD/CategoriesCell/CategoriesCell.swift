//
//  CategoriesCell.swift
//  
//
//  Created by Venkata Mandala on 29/10/2016.
//
//

import Foundation
import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet var categoryButton: UIButton!
    var categoryID: Int?
    
    override func awakeFromNib() {
        applyGradientAndShadow()
    }
    
    func applyGradientAndShadow()
    {
        categoryButton.setTitleColor(UIColor(white:0.3, alpha:1.0), for: .normal)
        categoryButton.layer.cornerRadius = 4.0
//        categoryButton.titleLabel!.font = UIFont.gtBoldFont(withSize: 16)
        let color1 = UIColor(white: 1.0, alpha: 0.7)
        let color2 = UIColor(white: 0.3, alpha: 1.0)
        
        categoryButton.backgroundColor = UIColor.clear
        
        categoryButton.layer.shadowColor = UIColor.black.cgColor
        categoryButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        categoryButton.layer.shadowOpacity = 0.7
        categoryButton.layer.shadowRadius = 0.0
        
        let mainLayer = CAGradientLayer()
        mainLayer.frame = categoryButton.layer.bounds
        
        mainLayer.colors = [color1.cgColor, color2.cgColor]
        
        mainLayer.locations = [0.0, 1.0]
        
        mainLayer.cornerRadius = categoryButton.layer.cornerRadius
        
        categoryButton.layer.insertSublayer(mainLayer, at: 0)
        
        applyTextShadow()
    }
    
    @IBAction func categoriesButtonSelected(_ sender: AnyObject) {
        let subCategoryVM = SubCategoryVM.init(categoryID: self.categoryID!)
        let subCategoriesVC = SubCategoryVC()
        subCategoriesVC.viewModel = subCategoryVM
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue:"NavigateToSubCategory"), object: subCategoriesVC)
    }
    
    func applyTextShadow() {
        categoryButton.titleLabel!.layer.shadowOpacity = 0.3
        categoryButton.titleLabel!.layer.shadowRadius = 0.5
        categoryButton.titleLabel!.layer.shadowColor = UIColor.black.cgColor
        categoryButton.titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    }
}
