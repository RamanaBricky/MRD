
import Foundation
import UIKit

protocol SubCategoryOptionsDelegate: class {
    func didCancel()
    func optionSelected(with indexPath: Int)
}
class SubCategoryOptions: UIView, UITableViewDelegate, UITableViewDataSource, SubCategoryOptionsViewDelegate {
    
    weak var delegate:SubCategoryOptionsDelegate?
    var selectedIndexPath:Int = 0
    var viewModel: SubCategoryOptionsViewModel {
        didSet {
        viewModel.delegate = self
        }
    }
    @IBOutlet var view: UIView!
    @IBOutlet weak var subCategoryOptionTableView: UITableView!
    
    init(viewModel vm: SubCategoryOptionsViewModel){
        viewModel = vm
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
        subCategoryOptionTableView.backgroundColor = UIColor.black
    }
    
    fileprivate func loadViewFromNib() -> UIView
    {
        let nib = UINib(nibName: String(describing: SubCategoryOptions.self), bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subSubCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryOptionCell", for: indexPath) as? SubCategoryOptionCell
        
        if cell == nil {
            cell = SubCategoryOptionCell(style: .default, reuseIdentifier: "SubCategoryOptionCell")
        }
        
       cell?.subCategoryOptionLabel.text = viewModel.subSubCategoryList[(indexPath as NSIndexPath).item + 1]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        delegate?.optionSelected(with: selectedIndexPath+1)
    }
}
