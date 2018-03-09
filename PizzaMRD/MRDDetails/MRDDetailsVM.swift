//
//  MRDDetailsVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
let madeDate = "madeDate"
let madeTime = "madeTime"
let readyDate = "readyDate"
let readyTime = "readyTime"
let discardDate = "discardDate"
let discardTime = "discardTime"

protocol MRDDetailsViewModel {
    weak var delegate:MRDDetailsDelegate? {get set}
    var selectedCategoryID:Int {get set}
    var selectedSubCategoryID:Int {get set}
    var selectedMRDType:Int? {get set}
    var subSubCategoryList:[String] {get}
    
    func getTitle() -> String?
    func getMRDDetails() -> [String:String]
}

protocol MRDDetailsDelegate:class {
    var viewModel: MRDDetailsViewModel? {get set}
}

class MRDetailsVM: MRDDetailsViewModel {
    
    weak var delegate:MRDDetailsDelegate?
    var selectedCategoryID: Int = 0
    var selectedSubCategoryID: Int = 0
    var selectedMRDType: Int?
    
    var subSubCategoryList: [String] {
        return DataStack.shared.subSubCategoryList(for: selectedCategoryID, selectedSubCategoryID)
    }
    
    func getTitle() -> String? {
        var title: String?
        let subCategoryText = DataStack.shared.subCategoryList(for: selectedCategoryID)[selectedSubCategoryID]
        if let mrdType = selectedMRDType {
            if let mrdTypeText = DataStack.shared.mrdType(for: selectedCategoryID, selectedSubCategoryID)[mrdType],
                mrdTypeText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
                title = ("\(subCategoryText!) - \(mrdTypeText)")
            }
            else {
                title = subCategoryText
            }
        }
        else {
            title = subCategoryText
        }
        return title
    }
    
    func getMRDDetails() -> [String:String] {
        let mrdStruct = DataStack.shared.mrdDataStruct(for: selectedCategoryID, selectedCategoryID)
        let date = Date()
        let mdDate = convertDateToString(date: date)
        let mdTime = date.toString(.none, timeStyle: .short)
        
        let index = selectedMRDType! == 0 ? 0:selectedMRDType! - 1
        let firstMRDStruct = mrdStruct[index]
        let rDate = calculateDateAndTime(date: date, frequency: firstMRDStruct.mRDReadyFrequency, interval: firstMRDStruct.mRDReadyInterval)
        
        let rdDate = convertDateToString(date: rDate)
        let rdTime = rDate.toString(.none, timeStyle: .short)
        
        var discDate = ""
        var discTime = ""
        if firstMRDStruct.mRDDiscardFrequency == .useByDate {
            discDate = "UBD"
            discTime = "UBD"
        }
        else {
            let dDate = calculateDateAndTime(date: rDate, frequency: firstMRDStruct.mRDDiscardFrequency, interval: firstMRDStruct.mRDDiscardInterval)
            discDate = convertDateToString(date: dDate)
            
            if firstMRDStruct.eod {
                discTime = "23:59"
            }
            else {
                discTime = dDate.toString(.none, timeStyle: .short)
            }
        }
        
        return [ "madeDate"    : mdDate,
                 "madeTime"    : mdTime,
                 "readyDate"   : rdDate,
                 "readyTime"   : rdTime,
                 "discardDate" : discDate,
                 "discardTime" : discTime
                ]
    }
    
    func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return "\(dateFormatter.string(from: date))"
    }
    
    func calculateDateAndTime(date: Date, frequency: Frequency = .useByDate, interval: Int = 0) -> Date{
        switch frequency
        {
        case .hours:
            return date.dateByAddingHours(interval)
        case .days:
            return date.dateByAddingDays(interval)
        default:
            return date
        }
    }
    
    
}
