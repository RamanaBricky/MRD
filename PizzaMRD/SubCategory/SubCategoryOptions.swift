//
//  SubCategoryOptions.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

protocol SubCategoryOptionsDelegate {
    func didCancel()
    func optionSelected(with indexPath: IndexPath)
}
class SubCategoryOptions: UIView {
    
    
    @IBOutlet weak var subCategoryOptionTableView: UITableView!
    
}
