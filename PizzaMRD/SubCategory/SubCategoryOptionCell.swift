//
//  SubCategoryOptionCell.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

class SubCategoryOptionCell: UITableViewCell {
    
    @IBOutlet weak var subCategoryOptionLabel: UILabel!
    
    @IBAction func switchSelectionAction(_ sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subCategoryOptionLabel.backgroundColor = Config.shared.viewBackgroundColor
        subCategoryOptionLabel.textColor = Config.shared.textColor
    }
}
