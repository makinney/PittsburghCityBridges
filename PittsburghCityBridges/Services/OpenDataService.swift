//
//  CityBridgesMetaDataService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/7/21.
//

import CloudKit
import Foundation

enum CityBridgesMetaDataError: Error {
    case noRecords
}

class OpenDataService {
    let container: CKContainer
    let publicDB: CKDatabase
    
    var openDataURL: String {
        get async throws {
            try await cityBridgesMetaData().geoJSONURL
        }
    }
    
    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        publicDB = container.publicCloudDatabase
    }
    
    func cityBridgesMetaData() async throws -> OpenDataMetaData {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: OpenDataMetaData.recordType, predicate: predicate)
        
        typealias CityBridgeContinuation = CheckedContinuation<OpenDataMetaData, Error>
        return try await withCheckedThrowingContinuation{ (continuation: CityBridgeContinuation) in
            publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                guard let records = records, let record = records.first else {
                    continuation.resume(throwing: CityBridgesMetaDataError.noRecords)
                    return
                }
                
                let metaData = OpenDataMetaData(record: record)
                continuation.resume(returning: metaData)
            }
        }
    }
}

class OpenDataMetaData {
    let title = "City of Pittsburgh Bridges"
    private(set) var geoJSONURL: String = ""
    private let recordID: CKRecord.ID
    static let recordType = "CityBridgesMetaData"
    init(record: CKRecord) {
        recordID = record.recordID
        geoJSONURL = record["geoJSONURL"] as? String ?? ""
    }
}
