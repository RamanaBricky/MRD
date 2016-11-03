//
//  PrintLabelView.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 03/11/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import UIKit

protocol PrintLabelDelegate: class {
    func didOK()
}

class PrintLabelView:UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var printInfoTableView: UITableView!
    weak var delegate: PrintLabelDelegate?
    var printInfo: [String]?
    @IBAction func oKButtonAction(_ sender: AnyObject) {
        delegate?.didOK()
    }
    
    init(printInfo: [String]){
        self.printInfo = printInfo
        super.init(frame: CGRect(x: 0,y: 0,width: 174,height: 255))
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
        let frame = CGRect(x: 0,y: 0,width: 300,height: 380)
        view.frame = frame
        bounds = view.frame
        view.layer.cornerRadius = 6.0
        addSubview(view)
        printInfoTableView.register(UINib.init(nibName: String(describing: SubCategoryOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SubCategoryOptionCell.self))
        printInfoTableView.tableFooterView = UIView()
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: PrintLabelView.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (printInfo?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as? SubCategoryOptionCell
        
        if cell == nil {
            cell = SubCategoryOptionCell(style: .default, reuseIdentifier: "SubCategoryOptionCell")
        }
        
        let row = indexPath.row
        cell?.subCategoryOptionLabel.text = printInfo?[row]
        
        return cell!
    }
}
