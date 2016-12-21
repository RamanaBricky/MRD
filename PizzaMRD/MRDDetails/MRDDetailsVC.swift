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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var madeLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfLabels: UILabel!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var mrdView: UIView!
	
	var selectedPrinter: UIPrinter?
	
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let defaults = UserDefaults.standard
		if let printerUrl = defaults.url(forKey: "printerURL") {
			selectedPrinter = UIPrinter(url: printerUrl)
			selectedPrinter?.contactPrinter({ reachable in
				if !reachable {
					self.selectedPrinter = nil
					defaults.removeObject(forKey: "printerURL")
					defaults.synchronize()
					AlertWindowView.sharedInstance.show("Attention!", "Your preferred printer in not reachable, please make sure the printer is ready or connect to another printer.")
				} else {
					let defaults = UserDefaults.standard
					defaults.set(self.selectedPrinter!.url, forKey: "printerURL")
					defaults.synchronize()
				}
			})
		}
	}
	
    var subSubCategoryList:[String]?
    var selectedIndexPath = -1
	
    func setupUI() {
        view.backgroundColor = UIColor.black
        madeLabel.textColor = UIColor.white
        readyLabel.textColor = UIColor.green
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
		
		let settingsButton = UIButton()
		settingsButton.setImage(UIImage.init(named: "button_settings"), for: .normal)
		settingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 27)
		settingsButton.addTarget(self, action: #selector(MRDDetailsVC.pickPrinter), for: .touchUpInside)
		let barButtonItem = UIBarButtonItem(customView: settingsButton)
		
		self.navigationItem.rightBarButtonItem = barButtonItem
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
            if mrdTypeText?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
                title = ("\(subCategoryText!) - \(mrdTypeText!)")
            }
            else {
               title = subCategoryText
            }
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
    
    @IBAction func printAction(_ sender: AnyObject) {
        let printArray = [title!,
                           madeDateTextField.text!, madeTimeTextField.text!,
                           readyDateTextField.text!, readyTimeTextField.text!,
                           discardDateTextField.text!, discardTimeTextField.text!]
        let printViewAlert = MRDPrintView.init(printInfo: printArray)
        printViewAlert.delegate = self
        printViewAlert.center = view.center
        
		if self.selectedPrinter == nil {
			showLabel(labelView: printViewAlert)
		} else {
            //remove OK Button
            let frame = printViewAlert.frame
            let newFrame = CGRect(origin: frame.origin, size: CGSize(width:frame.size.width, height:frame.size.height - printViewAlert.okButton.frame.size.height))
            printViewAlert.okButton.removeFromSuperview()
            printViewAlert.frame = newFrame
            
			printThis(mrdLabel: printViewAlert)
		}
    }
	
	func pickPrinter() {
		print("printer picked")
		let printerPicker = UIPrinterPickerController.init(initiallySelectedPrinter: selectedPrinter)
//MARK: TODO you can use shouldShowPrinter delegate method to show a printer in this list
		printerPicker.present(animated: true, completionHandler: { pickerController, selected, error in
			if selected {
				self.selectedPrinter = pickerController.selectedPrinter!
				self.selectedPrinter?.contactPrinter({ reachable in
//MARK: TODO display the spinner until this is done
					if !reachable {
						AlertWindowView.sharedInstance.show("Attention!", "Not able to connect to the printer, please try again.")
					} else {
                        let defaults = UserDefaults.standard
                        defaults.set(self.selectedPrinter!.url, forKey: "printerURL")
                        defaults.synchronize()
					}
				})
			}
		})
	}
	
    func showLabel(labelView: UIView) {
        AlertWindowView.sharedInstance.showWithView(labelView,
                                                    animations:{
                                                        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut,
                                                                       animations: {
                                                                        labelView.transform = CGAffineTransform.identity
                                                        },
                                                                       completion: {(completed) in})
        },dismissAnimations:{
            [weak labelView] in
            UIView.animate(withDuration: 0.3, animations: {
                if let overView = labelView
                {
                    overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
            })
        })
    }
    
	func printThis(mrdLabel: UIView) {
        printButton.isEnabled = false
        
		UIGraphicsBeginImageContextWithOptions(mrdLabel.bounds.size, false, 0.0)
		
		mrdLabel.drawHierarchy(in: mrdLabel.bounds, afterScreenUpdates: true)
		//pass this image to printer
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let printInfo = UIPrintInfo(dictionary:nil)
		printInfo.outputType = UIPrintInfoOutputType.grayscale
		printInfo.jobName = "MRD"
		
		// Set up print controller
		let printController = UIPrintInteractionController.shared
		printController.printInfo = printInfo
		
		// Assign an UIImage version of printView as a printing item
        if let text = printLabelCountTextField.text, let items = Int(text), let img = image {
            printController.printingItems = Array(repeating: img, count: items)
        } else {
            printController.printingItem = image
        }
        printController.print(to: selectedPrinter!, completionHandler: { (controller, result, error) in
            self.printButton.isEnabled = true
            if result {
               print("Job Completed")
            } else {
//				AlertWindowView.sharedInstance.show("Alert!", "Unable to print the label at the moment")
            }
        })
//MARK: TO DO
        //handle delegate methods to load paper, printer problems
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

extension MRDDetailsVC: UITableViewDataSource, UITableViewDelegate {
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

extension MRDDetailsVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 90)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x:0, y:0)
        })
    }
}

