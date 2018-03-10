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
    var categoryID: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyGradientAndShadow()
    }
    
    func applyGradientAndShadow()
    {
        subCategoryButton.setTitleColor(Config.shared.textColor, for:.normal)
        subCategoryButton.layer.cornerRadius = 4.0
        backgroundColor = Config.shared.cellBackgroundColor
    }
    
    func applyTextShadow() {
        subCategoryButton.titleLabel!.layer.shadowOpacity = 0.3
        subCategoryButton.titleLabel!.layer.shadowRadius = 0.5
        subCategoryButton.titleLabel!.layer.shadowColor = UIColor.black.cgColor
        subCategoryButton.titleLabel!.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    }
    
    @IBAction func subCategoriesButtonSelected(_ sender: AnyObject) {
        let userinfo: [String:Int] = ["cat":categoryID, "sub":subCategoryID]
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue:"SubCategorySelected"), object: nil, userInfo:userinfo)
    }
}
