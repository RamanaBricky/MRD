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

     init(catID:Int, subCatID:Int){
        self.viewModel = SubCategoryOptionsVM()
        subSubCategoryList = self.viewModel.getSubSubCategoryList(catID: catID, subCatID: subCatID)
        super.init(frame: CGRect(x: 0,y: 0,width: 250,height: 180))
    }
    
    override init(frame: CGRect)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("MarketCellOptions must be called with init(indexPath: NSIndexPath) method")
    }
    
    @IBOutlet weak var subCategoryOptionTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = SubCategoryOptionsVM()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSubCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as! SubCategoryOptionCell
        
        let row = indexPath.row
        cell.subCategoryOptionLabel.text = subSubCategoryList[row]
        
        return cell
    }
    
    @IBAction func CancelButtonAction(_ sender: AnyObject) {
        delegate?.didCancel()
    }
    
    @IBAction func selectAction(_ sender: AnyObject) {
        delegate?.optionSelected(with: selectedIndexPath)
    }
    
    
}
