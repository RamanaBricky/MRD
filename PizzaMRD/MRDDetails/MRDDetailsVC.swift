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
    @IBOutlet weak var subSubCategoryTableView: UITableView!
    @IBOutlet weak var printLabelCountTextField: UITextField!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillMRDDetails()
        subSubCategoryTableView.register(UINib.init(nibName: String(describing: SubCategoryOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubCategoryOptionCell.self))
        subSubCategoryTableView.tableFooterView = UIView()
        subSubCategoryTableView.layer.borderColor = UIColor.gray.cgColor
        subSubCategoryTableView.layer.borderWidth = 5.0
        
        if (subSubCategoryList?.count) != nil {
            let indexPath = IndexPath.init(row: 0, section: 0)
            selectedIndexPath = 0
            subSubCategoryTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        printLabelCountTextField.text = "1"
    }
    
    var subSubCategoryList:[String]?
    var selectedIndexPath = -1
    func fillMRDDetails() {
        let coreDataStack = CoreDataStack()
        let catID = viewModel?.selectedCategoryID
        let subCatID = viewModel?.selectedSubCategoryID
        let subCategoryText = coreDataStack.subCategoriesList[catID!]?[subCatID!]
        if let mrdType = viewModel?.selectedMRDType {
            let mrdTypeText = coreDataStack.mrdType[catID!]?[subCatID!]?[mrdType]
            titleLabel.text = ("\(subCategoryText!) - \(mrdTypeText!)")
        }
        else {
            titleLabel.text = subCategoryText
        }
        
        subSubCategoryList = coreDataStack.subSubCategoryList[catID!]?[subCatID!]
        print("something \((viewModel?.selectedCategoryID)!) \(subSubCategoryList!) \((viewModel?.selectedSubCategoryID)!)")
        
        let mrdStruct = coreDataStack.mrdDataStruct[catID!]?[subCatID!]
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
    
    @IBAction func printAction(_ sender: AnyObject) {
        
        let printArray = [(subSubCategoryList?[selectedIndexPath])!,
                            "Made",
                          "\(madeDateTextField.text!) - \(madeTimeTextField.text!)",
                            "Ready",
                            "\(readyDateTextField.text!) - \(readyTimeTextField.text!)",
                            "Discard",
                            "\(discardDateTextField.text!) - \(discardTimeTextField.text!)"]
        
        let printLabelAlert = PrintLabelView.init(printInfo: printArray)
        printLabelAlert.delegate = self
        printLabelAlert.center = view.center
        
        AlertWindowView.sharedInstance.showWithView(printLabelAlert,
                                                    animations:{
                                                        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut,
                                                                       animations: {
                                                                        printLabelAlert.transform = CGAffineTransform.identity
                                                            },
                                                                       completion: {(completed) in})
            },dismissAnimations:{
                [weak printLabelAlert] in
                UIView.animate(withDuration: 0.3, animations: {
                    if let overView = printLabelAlert
                    {
                        overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    }
                })
            })
    }
    
}

extension MRDDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (subSubCategoryList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as? SubCategoryOptionCell
        
        if cell == nil {
            cell = SubCategoryOptionCell(style: .default, reuseIdentifier: "SubCategoryOptionCell")
        }
        
        let row = indexPath.row
        cell?.subCategoryOptionLabel.text = subSubCategoryList?[row]
        
        return cell!
    }
}

extension MRDDetailsVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
    }
}

extension MRDDetailsVC:PrintLabelDelegate {
    func didOK() {
        AlertWindowView.sharedInstance.dismissAlert()
    }
}
