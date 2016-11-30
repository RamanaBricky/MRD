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
    
    
    @IBOutlet weak var madeLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfLabels: UILabel!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var mrdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillMRDDetails()
        subSubCategoryTableView.register(UINib.init(nibName: String(describing: SubCategoryOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubCategoryOptionCell.self))
        subSubCategoryTableView.tableFooterView = UIView()
        
        if (subSubCategoryList?.count) != nil {
            let indexPath = IndexPath.init(row: 0, section: 0)
            selectedIndexPath = 0
            subSubCategoryTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        printLabelCountTextField.text = "1"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MRDDetailsVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    var subSubCategoryList:[String]?
    var selectedIndexPath = -1
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        madeLabel.textColor = UIColor.red
        readyLabel.textColor = UIColor.red
        discardLabel.textColor = UIColor.red
        dateLabel.textColor = UIColor.red
        timeLabel.textColor = UIColor.red
        numberOfLabels.textColor = UIColor.red
        madeDateTextField.textColor = UIColor.red
        madeTimeTextField.textColor = UIColor.red
        readyDateTextField.textColor = UIColor.red
        readyTimeTextField.textColor = UIColor.red
        discardDateTextField.textColor = UIColor.red
        discardTimeTextField.textColor = UIColor.red
        
        subSubCategoryTableView.backgroundColor = UIColor.black
        printLabelCountTextField.textColor = UIColor.red
        
        subSubCategoryTableView.layer.borderColor = UIColor.gray.cgColor
        subSubCategoryTableView.layer.borderWidth = 5.0
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            mrdView.layer.borderColor = UIColor.lightGray.cgColor
            mrdView.layer.borderWidth = 1.0
        }
        applyGradientAndShadow()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fillMRDDetails() {
        let coreDataStack = CoreDataStack()
        let catID = viewModel?.selectedCategoryID
        let subCatID = viewModel?.selectedSubCategoryID
        let subCategoryText = coreDataStack.subCategoriesList[catID!]?[subCatID!]
        if let mrdType = viewModel?.selectedMRDType {
            let mrdTypeText = coreDataStack.mrdType[catID!]?[subCatID!]?[mrdType]
            title = ("\(subCategoryText!) - \(mrdTypeText!)")
        }
        else {
            title = subCategoryText
        }
        
        subSubCategoryList = coreDataStack.subSubCategoryList[catID!]?[subCatID!]
        print("something \((viewModel?.selectedCategoryID)!) \(subSubCategoryList!) \((viewModel?.selectedSubCategoryID)!)")
        
        let mrdStruct = coreDataStack.mrdDataStruct[catID!]?[subCatID!]
        print("dates \(mrdStruct!)")
        
        guard mrdStruct != nil else {
            return
        }

        let date = Date()
        
        madeDateTextField.text = convertDateToString(date: date)
        madeTimeTextField.text = date.toString(.none, timeStyle: .short)
        
        if !(mrdStruct?.isEmpty)! {
            if let firstMRDStruct = mrdStruct?[(viewModel?.selectedMRDType)!] {
                let rDate = calculateDateAndTime(date: date, frequency: firstMRDStruct.mRDReadyFrequency, interval: firstMRDStruct.mRDReadyInterval)
                
                readyDateTextField.text = convertDateToString(date: rDate)
                readyTimeTextField.text = rDate.toString(.none, timeStyle: .short)
                
                if firstMRDStruct.mRDDiscardFrequency == .useByDate {
                    discardDateTextField.text = "UBD"
                    discardTimeTextField.text = "UBD"
                }
                else {
                    let dDate = calculateDateAndTime(date: rDate, frequency: firstMRDStruct.mRDDiscardFrequency, interval: firstMRDStruct.mRDDiscardInterval)
                    discardDateTextField.text = convertDateToString(date: dDate)
                    
                    if firstMRDStruct.eod {
                        discardTimeTextField.text = "23:59"
                    }
                    else {
                        discardTimeTextField.text = dDate.toString(.none, timeStyle: .short)
                    }
                }
            }
        }
       
    }
    
    func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
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
    
    @IBAction func printAction(_ sender: AnyObject) {
        
//        let printArray = [(subSubCategoryList?[selectedIndexPath])!,
//                            "Made",
//                          "\(madeDateTextField.text!) - \(madeTimeTextField.text!)",
//                            "Ready",
//                            "\(readyDateTextField.text!) - \(readyTimeTextField.text!)",
//                            "Discard",
//                            "\(discardDateTextField.text!) - \(discardTimeTextField.text!)"]
//        
//        let printLabelAlert = PrintLabelView.init(printInfo: printArray)
//        printLabelAlert.delegate = self
//        printLabelAlert.center = view.center
        
        let printArray = [(subSubCategoryList?[selectedIndexPath])!,
                           madeDateTextField.text!, madeTimeTextField.text!,
                           readyDateTextField.text!, readyTimeTextField.text!,
                           discardDateTextField.text!, discardTimeTextField.text!]
        let printViewAlert = MRDPrintView.init(printInfo: printArray)
        printViewAlert.delegate = self
        printViewAlert.center = view.center
        AlertWindowView.sharedInstance.showWithView(printViewAlert,
                                                    animations:{
                                                        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut,
                                                                       animations: {
                                                                        printViewAlert.transform = CGAffineTransform.identity
                                                            },
                                                                       completion: {(completed) in})
            },dismissAnimations:{
                [weak printViewAlert] in
                UIView.animate(withDuration: 0.3, animations: {
                    if let overView = printViewAlert
                    {
                        overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    }
                })
            })
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    func applyGradientAndShadow()
    {
        printButton.setTitleColor(UIColor.red, for: .normal)
        printButton.layer.cornerRadius = 4.0
        //        categoryButton.titleLabel!.font = UIFont.gtBoldFont(withSize: 16)
        let color1 = UIColor(white: 1.0, alpha: 0.7)
        let color2 = UIColor(white: 0.3, alpha: 1.0)
        
        printButton.backgroundColor = UIColor.clear
        
        printButton.layer.shadowColor = UIColor.black.cgColor
        printButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        printButton.layer.shadowOpacity = 0.7
        printButton.layer.shadowRadius = 0.0
        
        let mainLayer = CAGradientLayer()
        mainLayer.frame = printButton.layer.bounds
        
        mainLayer.colors = [color1.cgColor, color2.cgColor]
        
        mainLayer.locations = [0.0, 1.0]
        
        mainLayer.cornerRadius = printButton.layer.cornerRadius
        
        printButton.layer.insertSublayer(mainLayer, at: 0)
        
        printButton.setTitleColor(UIColor.red, for: .normal)
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

extension MRDDetailsVC:PrintViewDelegate {
    func didOK() {
        AlertWindowView.sharedInstance.dismissAlert()
    }
}
