//
//  SubCategoryOptionsVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation

protocol SubCategoryOptionsViewModel {
    weak var delegate: SubCategoryOptionsViewDelegate? {get set}
    
    func getMRDList(catID:Int, subCatID:Int)->[String]
}

protocol SubCategoryOptionsViewDelegate: class {
    var viewModel: SubCategoryOptionsViewModel {get set}
}
class SubCategoryOptionsVM: SubCategoryOptionsViewModel {
    weak var delegate: SubCategoryOptionsViewDelegate?
    
    func getMRDList(catID:Int, subCatID:Int)->[String] {
        return DataStack.shared.mrdType[catID]![subCatID]!
    }
}
