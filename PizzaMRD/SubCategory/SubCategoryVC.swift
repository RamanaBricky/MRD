
import UIKit
import Foundation

class SubCategoryVC: UIViewController, SubCategoryViewModelDelegate {
    
    @IBOutlet weak var subCategoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesTitleLabel: UILabel!
    var catID:Int = 0
    var subCatID:Int = 0
    var viewModel:SubCategoryViewModel? {
        didSet{
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subCategoriesCollectionView.backgroundColor = UIColor.black
        self.navigationItem.title = viewModel?.title
        
        subCategoriesCollectionView.register(UINib.init(nibName: String(describing: SubCategoryCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SubCategoryCell.self))
        NotificationCenter.default.addObserver(self, selector: #selector(SubCategoryVC.subCategorySelected), name: NSNotification.Name(rawValue:"SubCategorySelected"), object: nil)
        
    }
	
	deinit {
		AlertWindowView.sharedInstance.dismissAlert()
	}
	
    func subCategorySelected(notification: Notification){
        
        let subCategoryOptionsDict = notification.userInfo
        catID = subCategoryOptionsDict!["cat"] as! Int
        subCatID = subCategoryOptionsDict!["sub"] as! Int
        
        if let mrdTypeArray = viewModel?.mrdTypeList(subCatID), mrdTypeArray.count <= 1 {
            //navigate to print screen
            navigateToPrintScreen()
        }
        else {
            //Show the MRD Type if there is any
            let subCategoryOptionsVM = SubCategoryOptionsVM(catID: catID, subCatID: subCatID)
            let subCategoryOptions = SubCategoryOptions(viewModel: subCategoryOptionsVM)
            subCategoryOptions.delegate = self
            subCategoryOptions.center = view.center
            
            AlertWindowView.sharedInstance.showWithView(subCategoryOptions,
                                                        animations:{
                    UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                        subCategoryOptions.transform = CGAffineTransform.identity
                                    },
                                   completion: {(completed) in})
                },dismissAnimations:{
                    [weak subCategoryOptions] in
                    UIView.animate(withDuration: 0.3, animations: {
                        if let overView = subCategoryOptions
                        {
                            overView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        }
                    })
                })
        }
    }
    
    func navigateToPrintScreen(selectedMRDType: Int = -1){
        let mrdDetailsVM = MRDetailsVM()
        mrdDetailsVM.selectedCategoryID = catID
        mrdDetailsVM.selectedSubCategoryID = subCatID
        if selectedMRDType != -1 {
            mrdDetailsVM.selectedMRDType = selectedMRDType
        }
        else {
            mrdDetailsVM.selectedMRDType = 0
        }
        
        let mrdDetailsVC = MRDDetailsVC()
        mrdDetailsVC.viewModel = mrdDetailsVM
        
        self.navigationController?.pushViewController(mrdDetailsVC, animated: true)
    }
}

extension SubCategoryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.subCategoryList!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = DataStack.nextAvailableIndex((viewModel?.subCategoryList)!, at: indexPath.row)
        let buttonTitle = (viewModel?.subCategoryList![index])! as String
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        cell.subCategoryID = index
        cell.categoryID = viewModel?.selectedCategoryID
        cell.subCategoryButton.setTitle(buttonTitle, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            if UIScreen.main.bounds.size.width >= 1024 {
                return CGSize.init(width: 320.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 330.0, height: 100.0)
            }
        }
        else{
            if UIScreen.main.bounds.size.width >= 768 {
                return CGSize.init(width: 365.0, height: 100.0)
            }
            else {
                return CGSize.init(width: 340.0, height: 100.0)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        subCategoriesCollectionView.reloadData()
        coordinator.animate(alongsideTransition: {
            context in
            self.subCategoriesCollectionView.collectionViewLayout.invalidateLayout()
            self.subCategoriesCollectionView.performBatchUpdates({
                self.subCategoriesCollectionView.setCollectionViewLayout(self.subCategoriesCollectionView.collectionViewLayout, animated: true)
            })
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension SubCategoryVC: SubCategoryOptionsDelegate {
    
    func didCancel(){
        AlertWindowView.sharedInstance.dismissAlert()
    }
    
    func optionSelected(with indexPath: Int){
        AlertWindowView.sharedInstance.dismissAlert()
        navigateToPrintScreen(selectedMRDType: indexPath)
    }
}
