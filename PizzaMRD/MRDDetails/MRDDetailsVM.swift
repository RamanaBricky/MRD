//
//  MRDDetailsVM.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

let titleString = "title"
let madeDateString = "madeDate"
let madeTimeString = "madeTime"
let readyDateString = "readyDate"
let readyTimeString = "readyTime"
let discardDateString = "discardDate"
let discardTimeString = "discardTime"

protocol MRDDetailsViewModel {
    var delegate:MRDDetailsDelegate? {get set}
    var selectedCategoryID:Int {get set}
    var selectedSubCategoryID:Int {get set}
    var selectedMRDType:Int? {get set}
    var subSubCategoryList:[String] {get}
    var mrdDictionary:[String:String] {get}
    
    func getPrintDetails() -> [String:String]
    func image(with inView: UIView) -> UIImage?
  func createPdfFromView(aView: UIView) -> NSMutableData?
}

protocol MRDDetailsDelegate:class {
    var viewModel: MRDDetailsViewModel? {get set}
}

class MRDetailsVM: MRDDetailsViewModel {
    weak var delegate:MRDDetailsDelegate?
    var selectedCategoryID: Int = 0
    var selectedSubCategoryID: Int = 0
    var selectedMRDType: Int?
    private var discardDate = Date()
    
    var mrdDictionary: [String:String] {
        let mrdStruct = DataStack.shared.mrdDataStruct(for: selectedCategoryID, selectedSubCategoryID)
        let date = Date()
        let mdDate = convertDateToString(date: date, format: "dd/MM")
//        let mdTime = covertTimeTo24Hrs(time: date.toString(.none, timeStyle: .short))
        let mdTime = date.toString(.none, timeStyle: .short)
        
        let index = selectedMRDType! == 0 ? 0:selectedMRDType! - 1
        let firstMRDStruct = mrdStruct[index]
        let rDate = calculateDateAndTime(date: date, frequency: firstMRDStruct.mRDReadyFrequency, interval: firstMRDStruct.mRDReadyInterval)
        
        let rdDate = convertDateToString(date: rDate, format: "dd/MM")
//        let rdTime = covertTimeTo24Hrs(time: rDate.toString(.none, timeStyle: .short))
        let rdTime = rDate.toString(.none, timeStyle: .short)
        
        var discDate = ""
        var discTime = ""
        if firstMRDStruct.mRDDiscardFrequency == .useByDate {
            discDate = "UBD"
            discTime = "UBD"
        }
        else {
            discardDate = calculateDateAndTime(date: rDate, frequency: firstMRDStruct.mRDDiscardFrequency, interval: firstMRDStruct.mRDDiscardInterval)
            discDate = convertDateToString(date: discardDate, format: "dd/MM")
            
            if firstMRDStruct.eod {
                discTime = "23:59"
            }
            else {
//              discTime = covertTimeTo24Hrs(time: discardDate.toString(.none, timeStyle: .short))
                discTime = discardDate.toString(.none, timeStyle: .short)
            }
        }
        
        return [ titleString       : getTitle(),
                 madeDateString    : mdDate,
                 madeTimeString    : mdTime,
                 readyDateString   : rdDate,
                 readyTimeString   : rdTime,
                 discardDateString : discDate,
                 discardTimeString : discTime
        ]
    }
    
    var subSubCategoryList: [String] {
        return DataStack.shared.subSubCategoryList(for: selectedCategoryID, selectedSubCategoryID)
    }
    
    private func getTitle() -> String {
        var title = ""
        let subCategoryText = DataStack.shared.subCategoryList(for: selectedCategoryID)[selectedSubCategoryID]!
        if let mrdType = selectedMRDType {
            if let mrdTypeText = DataStack.shared.mrdType(for: selectedCategoryID, selectedSubCategoryID)[mrdType],
                mrdTypeText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
                title = ("\(subCategoryText) - \(mrdTypeText)")
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
    
    func getPrintDetails() -> [String:String] {
      switch Config.shared.getLabelViewType() {
      case .bb:
        return [ titleString : getTitle(),
                 discardDateString : convertDateToString(date: discardDate, format: "dd/MM/YYYY")
        ]
      default:
        return mrdDictionary
      }
    }
  
  func image(with inView: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(inView.bounds.size, inView.isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
      inView.layer.render(in: context)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      return image
    }
    return nil
  }
  
  func createPdfFromView(aView: UIView) -> NSMutableData?
  {
    aView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
    UIGraphicsBeginPDFPage()
    
    guard let pdfContext = UIGraphicsGetCurrentContext() else { return nil }
    
    aView.layer.render(in: pdfContext)
    UIGraphicsEndPDFContext()
    return pdfData
  }
  
    private func convertDateToString(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return "\(dateFormatter.string(from: date))"
    }
  
//  private func covertTimeTo24Hrs(time: String) -> String {
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "h:mm a"
//
//    let date = dateFormatter.date(from: time)
//    dateFormatter.dateFormat = "HH:mm"
//
//    return dateFormatter.string(from: date!)
//  }
  
    private func calculateDateAndTime(date: Date, frequency: Frequency = .useByDate, interval: Int = 0) -> Date{
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
