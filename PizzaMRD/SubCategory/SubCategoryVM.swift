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
    
    init(categoryID:Int){
        selectedCategoryID = categoryID
        loadSubCategoryList()
    }
    
    func loadSubCategoryList() {
        let completeSubCategoryList = [ 1:[1:"Italian", 2:"SC/SB",3:"Classic",4:"Pan"],
                                        2:[1:"Meat",2:"Tins",3:"MOP",4:"Tomato/Chillies", 5:"Black Olives"],
                                        3:[1:"String",2:"Mozzarella",3:"Garlic String"],
                             4:[1:"Chicken",2:"GB Wedges",3:"Nachos",4:"Pasta",5:"Traiangles"],
                             5:[1:"Sauce", 2:"BBQ Sauce", 3:"Salsa"],
                             6:[1:"Cookie Dough", 2:"Doughnuts", 3:"Brownies"],
                             7:[1:"Onions/Tomatoes", 2:"Pepper"],
                             8:[1:"Garlic Sprinkles"]
                            ]
        subCategoryList = completeSubCategoryList[selectedCategoryID]
    }
}
