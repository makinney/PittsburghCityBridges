//
//  WPDataCenterModelController.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/7/21.
//

import CloudKit
import Foundation


class CityBridgesCloudKitAccess {
    let container: CKContainer
    let publicDB: CKDatabase
    private(set) var wpOpenData: WPOpenData?
    
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
    }
    
    @objc func refreshOpenDataURLs(_ completion: @escaping (Error?) -> Void ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: WPOpenData.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
          guard let self = self else { return }
          if let error = error {
            DispatchQueue.main.async {
              completion(error)
            }
            return
          }
          guard let results = results else { return }
            if  let result = results.first {
                self.wpOpenData = WPOpenData(record: result, database: self.publicDB)
            }
          DispatchQueue.main.async {
            completion(nil)
          }
        }
    }
}


class WPOpenData {
    
    var cityBridgesURL: String?
    
    static let recordType = "WPOpenData"
    private let recordID: CKRecord.ID
    
    init?(record: CKRecord, database: CKDatabase) {
        recordID = record.recordID
        cityBridgesURL = record["cityBridgesURL"] as? String
    }
    
}
