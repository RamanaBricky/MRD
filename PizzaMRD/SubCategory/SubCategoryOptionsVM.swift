
import Foundation

protocol SubCategoryOptionsViewModel {
    weak var delegate: SubCategoryOptionsViewDelegate? {get set}
    var subSubCategoryList: [Int:String] {get set}
}

protocol SubCategoryOptionsViewDelegate: class {
    var viewModel: SubCategoryOptionsViewModel {get set}
}
class SubCategoryOptionsVM: SubCategoryOptionsViewModel {
    weak var delegate: SubCategoryOptionsViewDelegate?
    var subSubCategoryList: [Int : String]
    private let categoryID:Int
    private let subCategoryID:Int
    
    init(catID: Int, subCatID: Int) {
        categoryID = catID
        subCategoryID = subCatID
        subSubCategoryList = DataStack.shared.mrdType(for: categoryID, subCategoryID)
    }
}
