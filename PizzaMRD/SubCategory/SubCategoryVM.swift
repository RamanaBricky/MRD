//
//  SubCategoryVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation

protocol SubCategoryViewModel {
    var selectedCategoryID:Int {get set}
    var subCategoryList:Dictionary<Int,String>? {get}
    var title: String {get}
    weak var delegate:SubCategoryViewModelDelegate?{get set}
}

protocol SubCategoryViewModelDelegate:class {
    var viewModel:SubCategoryViewModel?{get set}
}

class SubCategoryVM:SubCategoryViewModel {
    var subCategoryList:Dictionary<Int,String>?
    var selectedCategoryID:Int = 0
    var selectedCategoryTitle: String?
    weak var delegate: SubCategoryViewModelDelegate?
    
    var title: String {
        return DataStack.shared.categoriesList[selectedCategoryID]!
    }
    
    init(categoryID:Int){
        selectedCategoryID = categoryID
        loadSubCategoryList()
    }
    
    func loadSubCategoryList() {
        subCategoryList = DataStack.shared.subCategoryList(for: selectedCategoryID)
    }
}
