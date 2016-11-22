//
//  SubCategoryOptions.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 31/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

protocol SubCategoryOptionsDelegate: class {
    func didCancel()
    func optionSelected(with indexPath: Int)
}
class SubCategoryOptions: UIView, UITableViewDelegate, UITableViewDataSource, SubCategoryOptionsViewDelegate {
    weak var delegate:SubCategoryOptionsDelegate?
    var subSubCategoryList:[String]
    var selectedIndexPath:Int = 0
    var viewModel: SubCategoryOptionsViewModel {
        didSet {
        viewModel.delegate = self
        }
    }
    @IBOutlet var view: UIView!
    @IBOutlet weak var subCategoryOptionTableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
     init(catID:Int, subCatID:Int){
        self.viewModel = SubCategoryOptionsVM()
        subSubCategoryList = self.viewModel.getMRDList(catID: catID, subCatID: subCatID)
        super.init(frame: CGRect(x: 0,y: 0,width: 250,height: 180))
        nibSetup()
    }
    
    override init(frame: CGRect)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    fileprivate func nibSetup()
    {
        backgroundColor = UIColor.clear
        view = loadViewFromNib()
        let frame = CGRect(x: 0,y: 0,width: 300,height: 280)
        view.frame = frame
        bounds = view.frame
        view.layer.cornerRadius = 6.0
        addSubview(view)
        subCategoryOptionTableView.register(UINib.init(nibName: String(describing: SubCategoryOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubCategoryOptionCell.self))
        subCategoryOptionTableView.tableFooterView = UIView()
        selectButton.isEnabled = false
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: SubCategoryOptions.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = SubCategoryOptionsVM()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSubCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as? SubCategoryOptionCell
        
        if cell == nil {
            cell = SubCategoryOptionCell(style: .default, reuseIdentifier: "SubCategoryOptionCell")
        }
        
       let row = indexPath.row
       cell?.subCategoryOptionLabel.text = subSubCategoryList[row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        delegate?.optionSelected(with: selectedIndexPath)
//        selectButton.isEnabled = true
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        selectedIndexPath = indexPath.row
//    }
//    @IBAction func CancelButtonAction(_ sender: AnyObject) {
//        delegate?.didCancel()
//    }
//    
//    @IBAction func selectAction(_ sender: AnyObject) {
//        delegate?.optionSelected(with: selectedIndexPath)
//    }
}
