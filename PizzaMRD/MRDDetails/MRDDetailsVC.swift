//
//  MRDDetailsVC.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 01/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

class MRDDetailsVC: UIViewController, MRDDetailsDelegate {
    
    var viewModel: MRDDetailsViewModel? {
        didSet{
            viewModel?.delegate = self
        }
    }
    
    @IBOutlet weak var madeDateTextField: UITextField!
    @IBOutlet weak var madeTimeTextField: UITextField!
    @IBOutlet weak var readyDateTextField: UITextField!
    @IBOutlet weak var readyTimeTextField: UITextField!
    @IBOutlet weak var discardDateTextField: UITextField!
    @IBOutlet weak var discardTimeTextField: UITextField!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillMRDDetails()
    }
    
    func fillMRDDetails() {
        let coreDataStack = CoreDataStack()
        titleLabel.text = coreDataStack.subCategoriesList[(viewModel?.selectedCategoryID)!]?[(viewModel?.selectedSubCategoryID)!]
        
        let subSubCategory = coreDataStack.subSubCategoryList[(viewModel?.selectedCategoryID)!]?[(viewModel?.selectedSubCategoryID)!]
        print("something \((viewModel?.selectedCategoryID)!) \(subSubCategory!) \((viewModel?.selectedSubCategoryID)!)")
        
        let mrdStruct = coreDataStack.mrdDataStruct[(viewModel?.selectedCategoryID)!]?[(viewModel?.selectedSubCategoryID)!]
        print("dates \(mrdStruct!)")
        
        guard mrdStruct != nil else {
            return
        }

        let date = Date()
        
        madeDateTextField.text = date.toString(.short, timeStyle: .none)
        madeTimeTextField.text = date.toString(.none, timeStyle: .short)
        
        if !(mrdStruct?.isEmpty)! {
            if let firstMRDStruct = mrdStruct?[0] {
                let (rDate,rTime) = calculateDateAndTime(frequency: firstMRDStruct.mRDReadyFrequency, interval: firstMRDStruct.mRDReadyInterval)
                readyDateTextField.text = rDate
                readyTimeTextField.text = rTime
                
                let (dDate,dTime) = calculateDateAndTime(frequency: firstMRDStruct.mRDDiscardFrequency, interval: firstMRDStruct.mRDDiscardInterval)
                discardDateTextField.text = dDate
                discardTimeTextField.text = dTime
            }
        }
       
    }
    
    func calculateDateAndTime(frequency: Frequency = .undefined, interval: Int = 0) -> (String,String){
        
        let date = Date()

        switch frequency
        {
            case .hours:
                let addedHours = date.dateByAddingHours(interval)
                return (addedHours.toString(.short, timeStyle: .none), addedHours.toString(.none, timeStyle: .short))
            case .days:
                let addedDays = date.dateByAddingDays(interval)
                return (addedDays.toString(.short, timeStyle: .none), addedDays.toString(.none, timeStyle: .short))
            default:
                return (" ", " ")
        }
    }
}
