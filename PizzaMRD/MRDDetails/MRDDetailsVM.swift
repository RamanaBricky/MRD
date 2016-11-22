//
//  MRDDetailsVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation

protocol MRDDetailsViewModel {
    weak var delegate:MRDDetailsDelegate? {get set}
    var selectedCategoryID:Int {get set}
    var selectedSubCategoryID:Int {get set}
    var selectedMRDType:Int? {get set}
}

protocol MRDDetailsDelegate:class {
    var viewModel: MRDDetailsViewModel? {get set}
}

class MRDetailsVM: MRDDetailsViewModel {
    
    weak var delegate:MRDDetailsDelegate?
    var selectedCategoryID: Int = 0
    var selectedSubCategoryID: Int = 0
    var selectedMRDType: Int?
}
