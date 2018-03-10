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
    @IBOutlet weak var mainView: UIView!
    
	var selectedPrinter: UIPrinter?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillMRDDetails()
        subSubCategoryTableView.register(UINib.init(nibName: String(describing: SubCategoryOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubCategoryOptionCell.self))
        subSubCategoryTableView.tableFooterView = UIView()
        
        if (viewModel?.subSubCategoryList.count) != nil {
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
	
    var selectedIndexPath = -1
	
    func setupUI() {
        view.backgroundColor = Config.shared.viewBackgroundColor
        mainView.backgroundColor = Config.shared.viewBackgroundColor
        mrdView.backgroundColor = Config.shared.viewBackgroundColor
        
        madeLabel.textColor = UIColor.white
        readyLabel.textColor = UIColor.green
        discardLabel.textColor = UIColor.red
        dateLabel.textColor = Config.shared.staticTextColor
        timeLabel.textColor = Config.shared.staticTextColor
        numberOfLabels.textColor = Config.shared.staticTextColor
        madeDateTextField.textColor = Config.shared.textColor
        madeTimeTextField.textColor = Config.shared.textColor
        readyDateTextField.textColor = Config.shared.textColor
        readyTimeTextField.textColor = Config.shared.textColor
        discardDateTextField.textColor = Config.shared.textColor
        discardTimeTextField.textColor = Config.shared.textColor
        
        subSubCategoryTableView.backgroundColor = Config.shared.viewBackgroundColor
        printLabelCountTextField.textColor = Config.shared.textColor
        
        subSubCategoryTableView.layer.borderColor = Config.shared.primaryColor.cgColor
        subSubCategoryTableView.layer.borderWidth = 5.0
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            mrdView.layer.borderColor = UIColor.lightGray.cgColor
            mrdView.layer.borderWidth = 1.0
        }
        printButton.backgroundColor = Config.shared.tertiaryColor
        printButton.layer.cornerRadius = 4.0
        printButton.setTitleColor(Config.shared.textColor, for: .normal)
		
		let settingsButton = UIButton()
		settingsButton.setImage(UIImage.init(named: "button_settings"), for: .normal)
		settingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 27)
        settingsButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 27.0).isActive = true
		settingsButton.addTarget(self, action: #selector(MRDDetailsVC.pickPrinter), for: .touchUpInside)
		let barButtonItem = UIBarButtonItem(customView: settingsButton)
		
		self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
	
    func fillMRDDetails() {
        if let mrdDetails = viewModel?.mrdDictionary {
            title = mrdDetails[titleString]
            madeDateTextField.text = mrdDetails[madeDateString]
            madeTimeTextField.text = mrdDetails[madeTimeString]
            readyDateTextField.text = mrdDetails[readyDateString]
            readyTimeTextField.text = mrdDetails[readyTimeString]
            discardDateTextField.text = mrdDetails[discardDateString]
            discardTimeTextField.text = mrdDetails[discardTimeString]
        }
    }
    
    @IBAction func printAction(_ sender: AnyObject) {
        let printViewAlert = getPrintView()
        printViewAlert.center = view.center
		if self.selectedPrinter == nil {
			showLabel(labelView: printViewAlert)
		} else {
			printThis(mrdLabel: printViewAlert)
		}
    }
	
  func getPrintView() -> UIView {
    let printDetails = viewModel!.getPrintDetails()
    var printViewAlert : UIView!
    switch Config.shared.getLabelViewType() {
    case .bb:
      printViewAlert = BestBeforePrintView.init(printInfo: printDetails)
    default:
      printViewAlert = MRDPrintView.init(printInfo: printDetails)
    }
    return printViewAlert
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
		labelView.frame.size.width = 115.0
		labelView.center = view.center
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
    
    guard let data = viewModel?.createPdfFromView(aView: mrdLabel) else {
      return
    }
    let printInfo = UIPrintInfo(dictionary:nil)
    printInfo.outputType = UIPrintInfoOutputType.photoGrayscale
    printInfo.jobName = "MRD"

    // Set up print controller
    let printController = UIPrintInteractionController.shared
    printController.printInfo = printInfo

    // Assign an UIImage version of printView as a printing item
        if let text = printLabelCountTextField.text, let items = Int(text) {
            printController.printingItems = Array(repeating: data, count: items)
        } else {
            printController.printingItem = data
        }
        printController.print(to: selectedPrinter!, completionHandler: { (controller, result, error) in
            self.printButton.isEnabled = true
            if result {
               print("Job Completed")
            } else {
                controller.printingItems = nil
                controller.printingItem = nil
                controller.dismiss(animated: true)
        AlertWindowView.sharedInstance.show("Alert!", "Unable to print the label at the moment")
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
}

extension MRDDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.subSubCategoryList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as? SubCategoryOptionCell
        
        if cell == nil {
            cell = SubCategoryOptionCell(style: .default, reuseIdentifier: "SubCategoryOptionCell")
        }
        
        let row = indexPath.row
        cell?.subCategoryOptionLabel.text = viewModel?.subSubCategoryList[row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
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

