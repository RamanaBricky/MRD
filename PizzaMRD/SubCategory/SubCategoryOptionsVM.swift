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
    
    func getSubSubCategoryList(catID:Int, subCatID:Int)->[String]
}

protocol SubCategoryOptionsViewDelegate: class {
    var viewModel: SubCategoryOptionsViewModel {get set}
}
class SubCategoryOptionsVM: SubCategoryOptionsViewModel {
    weak var delegate: SubCategoryOptionsViewDelegate?
    
    var subSubCategoryList = [1:[1:["L Italian","M Italian","S Italian"],2:["SC/CB"],3:["Classic"],4:["L Pan","M Pan"]],
                              2:[1:["Chicken","Cajun","Pepperoni","Ham","Beef","Pork","Bacon"], 2:["Tuna","Anchovies","Jalapenos","Sweetcorn","Black Olives","Pineapple"], 3:["Onions","Mushrooms","Peppers"], 4:["Tomatoes"]],
                              3:[1:["String Cheese"], 2:["Mozzarella 1","Mozzarella 2","Mozzarella 3"]],
                              4:[1:["Strips","Spicy Strips", "BBQ Wings"], 2:["Garlic Bread","Wedges"], 3:["Nachos"], 4:["Pasta"], 5:["Triangles"]],
                              5:[1:["Sauce"], 2:["BBQ Sauce"], 3:["Salsa"]],
                              6:[1:["Choco Chip", "Caramel"], 2:["Doughnuts"], 3:["Brownies"]],
                              7:[1:["Onions", "Mushrooms", "Tomatoes"], 2:["Peppers"]],
                              8:[1:["Garlic Sprinkle"], 2:["Chipotle","Habanera", "Naga"]]
                         ]
    
    func getSubSubCategoryList(catID:Int, subCatID:Int)->[String] {
        let subCategoryList = subSubCategoryList[catID]!
        return subCategoryList[subCatID]!
    }
}
