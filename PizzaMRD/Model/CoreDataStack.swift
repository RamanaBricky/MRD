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
    static let db = try! Connection("\(Bundle.main.resourcePath!)/\(Bundle.main.infoDictionary!["Database_FileName"]!).db")
    
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
    
    static func sqlMRDStruct(_ query: String) -> [MRDData] {
        var array: [MRDData] = []
        for row in try! db.prepare(query) {
            if let typeID = row[0] as? Int64,
               let typeTitle = row[1] as? String,
               let readyFrequency = row[2] as? String,
               let readyInterval = row[3] as? Int64,
               let discardFrequency = row[4] as? String,
               let discardInterval = row[5] as? Int64,
                let eod = row[6] as? Int64 {
                array.append(MRDData(Int(typeID), typeTitle, Frequency(rawValue: readyFrequency)!, Int(readyInterval), Frequency(rawValue: discardFrequency)!, Int(discardInterval), eod == 0 ? false:true))
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
    
    func mrdType(for categoryID: Int, _ subCategoryID: Int) -> [Int:String] {
        return SqlStore.sqlQuery("SELECT mrd_type, mrd_type_desc from tbl_MRD_Type where MRD_Category = '\(categoryID)' AND MRD_Sub_Category = '\(subCategoryID)' ORDER BY mrd_type")
    }
    
    func mrdDataStruct(for categoryID: Int, _ subCategoryID: Int) -> [MRDData] {
        return SqlStore.sqlMRDStruct("SELECT MRD_Type, MRD_Type_Desc, MRD_Ready_Frequency, MRD_Ready_Interval, MRD_Discard_Frequency, MRD_Discard_Interval, MRD_EOD FROM tbl_MRD_Type WHERE MRD_Category = '\(categoryID)' AND MRD_Sub_Category = '\(subCategoryID)'")
    }
}
