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
    var categoriesList = CoreDataStack().categoriesList
}
