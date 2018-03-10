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
        backgroundColor = Config.shared.cellBackgroundColor
        categoryButton.setTitleColor(Config.shared.textColor, for: .normal)
        categoryButton.titleLabel?.numberOfLines = 0
        categoryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        categoryButton.titleLabel?.lineBreakMode = .byWordWrapping
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
        categoryButton.titleLabel!.layer.shadowColor = UIColor.white.cgColor
        categoryButton.titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    }
}
