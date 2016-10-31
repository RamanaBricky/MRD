//
//  SubCategoryCell.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class SubCategoryCell: UICollectionViewCell {

    @IBOutlet var subCategoryButton: UIButton!
    var subCategoryID: Int!
    
    override func awakeFromNib() {
        applyGradientAndShadow()
    }
    
    func applyGradientAndShadow()
    {
        subCategoryButton.setTitleColor(UIColor(white:0.3, alpha:1.0), for: .normal)
        subCategoryButton.layer.cornerRadius = 4.0
        //        categoryButton.titleLabel!.font = UIFont.gtBoldFont(withSize: 16)
        let color1 = UIColor(white: 1.0, alpha: 0.7)
        let color2 = UIColor(white: 0.3, alpha: 1.0)
        
        subCategoryButton.backgroundColor = UIColor.clear
        
        subCategoryButton.layer.shadowColor = UIColor.black.cgColor
        subCategoryButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        subCategoryButton.layer.shadowOpacity = 0.7
        subCategoryButton.layer.shadowRadius = 0.0
        
        let mainLayer = CAGradientLayer()
        mainLayer.frame = subCategoryButton.layer.bounds
        
        mainLayer.colors = [color1.cgColor, color2.cgColor]
        
        mainLayer.locations = [0.0, 1.0]
        
        mainLayer.cornerRadius = subCategoryButton.layer.cornerRadius
        
        subCategoryButton.layer.insertSublayer(mainLayer, at: 0)
        
        applyTextShadow()
    }
    
    func applyTextShadow() {
        subCategoryButton.titleLabel!.layer.shadowOpacity = 0.3
        subCategoryButton.titleLabel!.layer.shadowRadius = 0.5
        subCategoryButton.titleLabel!.layer.shadowColor = UIColor.black.cgColor
        subCategoryButton.titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    }
    
    @IBAction func subCategoriesButtonSelected(_ sender: AnyObject) {
        let obj = (1,1,["L","M","S"])
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue:"SubCategorySelected"), object: obj)
    }
}
