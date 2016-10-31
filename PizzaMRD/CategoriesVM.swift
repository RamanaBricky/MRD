//
//  CategoriesVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 29/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation

protocol CategoriesViewModel {
    weak var delegate:CategoriesViewModelDelegate?{get set}
    var categoriesList: Dictionary<Int,String>{get}
}

protocol CategoriesViewModelDelegate:class {
    
}

class CategoriesVM: CategoriesViewModel {
    weak var delegate:CategoriesViewModelDelegate?
    var categoriesList = [1:"Dough",2:"Toppings",3:"Cheese",4:"Starters", 5:"Sauce",6:"Desserts",7:"Deliveries",8:"Miscellaneous"]
}
