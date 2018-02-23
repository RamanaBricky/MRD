//
//  DataStack.swift
//  PizzaMRD
//
//  Created by Venkata Mandala on 30/10/2016.
//  Copyright © 2016 Ramana Reddy. All rights reserved.
//

import Foundation
import CoreData
import SQLite

enum Frequency:String {
    case hours =  "h"
    case days = "d"
    case useByDate = "u"
}

enum MRDType:Int {
    case one
    case two
    case three
}

struct MRDData {
    var typeID = 1
    var typeTitle = ""
    var mRDReadyFrequency = Frequency.hours
    var mRDReadyInterval = 0
    var mRDDiscardFrequency = Frequency.hours
    var mRDDiscardInterval = 0
    var eod = true
    
    init(_ typeID: Int, _ typeTitle: String, _ mRDReadyFrequency: Frequency, _ mRDReadyInterval: Int, _ mRDDiscardFrequency: Frequency, _ mRDDiscardInterval: Int, _ eod: Bool = true) {
        self.typeID = typeID
        self.typeTitle = typeTitle
        self.mRDReadyFrequency = mRDReadyFrequency
        self.mRDReadyInterval = mRDReadyInterval
        self.mRDDiscardFrequency = mRDDiscardFrequency
        self.mRDDiscardInterval = mRDDiscardInterval
        self.eod = eod
    }
}

class SqlStore {
    static let db = try! Connection("\(Bundle.main.resourcePath!)/MRD.db")
    
   static func sqlQuery(_ query: String) -> [Int:String] {
        var dictionary: Dictionary<Int,String> = Dictionary()
        for row in try! db.prepare(query) {
            if let key = row[0] as? Int64, let value = row[1] as? String {
                dictionary[Int(key)] = value
            }
        }
        return dictionary
    }
    
    static func sqlQueryArray(_ query: String) -> [String] {
        var array: [String] = []
        for row in try! db.prepare(query) {
            if let value = row[0] as? String {
                array.append(value)
            }
        }
        return array
    }
}

class DataStack: NSObject {
    
    static let shared = DataStack()
    
    static let moduleName = "MRD"
    let categoriesList = SqlStore.sqlQuery("SELECT * FROM tbl_MRD_Categories")
    
    func subCategoryList(for categoryID: Int) -> [Int:String] {
        return SqlStore.sqlQuery("SELECT Sub_Category, Sub_Category_Name FROM tbl_MRD_Sub_Categories where CategoryID = '\(categoryID)'")
    }
    
    func subSubCategoryList(for categoryID: Int, _ subCategoryID: Int) -> [String] {
        return SqlStore.sqlQueryArray("SELECT Title from tblSubSubCategory where Category = '\(categoryID)' AND Sub_Category = '\(subCategoryID)'")
    }
    
    let mrdType = [1:[1:["Defrost","S&C","BBQ"],
                      2:["Defrost","S&C","BBQ"],
                      3:["Defrost","S&C","BBQ"],
                      4:["Defrost","S&C","BBQ"]],
                   2:[1:[" "],
                      2:["Open"],
                      3:[" "],
                      4:[" "],
                      5:[" "]],
                   3:[1:[""],
                      2:["One Stack", "Two Stack", "Three Stack"],
                      3:[" "]],
                   4:[1:[" "],
                      2:["Plain", "Ready Topped", "Frozen Topped"],
                      3:["Open Bag", "Panned", "Pre-topped"],
                      4:[""],
                      5:[""]],
                   5:[1:[" "],
                      2:["Open"],
                      3:["Open"]],
                   6:[1:[" "],
                      2:[""],
                      3:[""]],
                   7:[1:[" "],
                      2:[""]],
                   8:[1:[" "],
                      2:[""]]]
    
    var mrdDataStruct:[Int:[Int:[MRDData]]]{
        return [1:[1:[MRDData(1,"Defrost", .hours, 12, .days, 3, false), MRDData(2, "S&C", .hours, 0, .hours, 6, false), MRDData(3, "BBQ", .hours, 0, .hours, 6, false)],
                   2:[MRDData(1,"Defrost", .hours, 12, .days, 3, false), MRDData(2, "S&C", .hours, 0, .hours, 4, false), MRDData(3, "BBQ", .hours, 0, .hours, 4, false)],
                   3:[MRDData(1,"Defrost", .days, 1, .days, 3, false), MRDData(2, "S&C", .hours, 0, .hours, 6, false), MRDData(3, "BBQ", .hours, 0, .hours, 6, false)],
                   4:[MRDData(1,"Defrost", .hours, 6, .hours, 26, false), MRDData(2, "S&C", .hours, 0, .hours, 4, false), MRDData(3, "BBQ", .hours, 0, .hours, 4, false)]],
                2:[1:[MRDData(1," ", .days, 1, .days, 3)],
                   2:[MRDData(1,"Open", .hours, 0, .days, 2)],
                   3:[MRDData(1," ", .hours, 0, .days, 1)],
                   4:[MRDData(1," ", .hours, 0, .days, 0)],
                   5:[MRDData(1," ", .hours, 0, .days, 13)]],
                3:[1:[MRDData(1," ", .days, 3, .days, 6)],
                   2:[MRDData(1,"One Stack", .days, 1, .days, 6), MRDData(2, "Two Stack", .days, 2, .days, 6), MRDData(3, "Three Stack", .days, 3, .days, 6)],
                   3: [MRDData(1, " ", .days, 1, .days, 6)]],
                4:[1:[MRDData(1," ", .days, 1, .days, 2)],
                   2:[MRDData(1,"Plain", .days, 1, .days, 2), MRDData(2, "Ready Topped", .hours, 0, .days, 0), MRDData(3, "Frozen Topped", .days, 1, .days, 0)],
                   3:[MRDData(1,"Open Bag", .hours, 0, .days, 27), MRDData(2, "Panned", .hours, 0, .days, 1), MRDData(3, "Pre-topped", .hours, 0, .hours, 4, false)],
                   4:[MRDData(1," ", .days, 1, .days, 3)],
                   5:[MRDData(1," ", .days, 1, .days, 2)]],
                5:[1:[MRDData(1," ", .hours, 1, .days, 3)],
                   2:[MRDData(1,"Open", .hours, 0, .days, 13)],
                   3:[MRDData(1,"Open", .hours, 0, .days, 27)]],
                6:[1:[MRDData(1," ", .days, 1, .days, 13)],
                   2:[MRDData(1," ", .hours, 1, .days, 1)],
                   3:[MRDData(1," ", .days, 1, .days, 2)]],
                7:[1:[MRDData(1," ", .hours, 0, .days, 9)],
                   2:[MRDData(1," ", .hours, 0, .days, 4)]],
                8:[1:[MRDData(1," ", .hours, 0, .days, 27)],
                   2:[MRDData(1," ", .hours, 0, .days, 13)]]]
    }
}
