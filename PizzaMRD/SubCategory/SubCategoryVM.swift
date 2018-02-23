
import Foundation

protocol SubCategoryViewModel {
    var selectedCategoryID:Int {get set}
    var subCategoryList:Dictionary<Int,String>? {get}
    var title: String {get}
    weak var delegate:SubCategoryViewModelDelegate?{get set}
    func mrdTypeList(_ subCategoryID: Int) -> [Int:String]?
}

protocol SubCategoryViewModelDelegate:class {
    var viewModel:SubCategoryViewModel?{get set}
}

class SubCategoryVM:SubCategoryViewModel {
    var subCategoryList:Dictionary<Int,String>?
    var selectedCategoryID:Int = 0
    var selectedCategoryTitle: String?
    weak var delegate: SubCategoryViewModelDelegate?
    
    var title: String {
        return DataStack.shared.categoriesList[selectedCategoryID]!
    }
    
    init(categoryID:Int){
        selectedCategoryID = categoryID
        loadSubCategoryList()
    }
    
    func loadSubCategoryList() {
        subCategoryList = DataStack.shared.subCategoryList(for: selectedCategoryID)
    }
    
    func mrdTypeList(_ subCategoryID: Int) -> [Int:String]? {
        return DataStack.shared.mrdType(for: selectedCategoryID, subCategoryID)
    }
}
