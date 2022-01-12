//
//  CityBridgesMetaDataService.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/7/21.
//

import CloudKit
import Foundation
import os

enum CityBridgesMetaDataError: Error {
    case noRecords
}

class OpenDataService {
    let container: CKContainer
    let publicDB: CKDatabase
    var serverURL: URL?
    let openDataFileSystem: OpenDataFileSystem
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)

//    var openDataURL: String {
//        get async throws {
//            try await cityBridgesMetaData().geoJSONURL
//        }
//    }
    
    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        self.openDataFileSystem = OpenDataFileSystem()
        publicDB = container.publicCloudDatabase
    }
    
    func getBridgesJSON() async -> Data? {
        if serverURL == nil {
            serverURL = await bridgeJSONServerURL()
        }
        return await openDataFileSystem.getBridges(url: serverURL)
    }
    
    private func bridgeJSONServerURL() async -> URL? {
        var url: URL?
        do {
            let metaData = try await cityBridgesMetaData()
            let urlPath = metaData.geoJSONURL
            url = URL(string: urlPath)
            if url == nil{
                logger.error("\(#file) \(#function) Could not create URL from path \(urlPath, privacy: .public)")
            }
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return url
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
         //           continuation.resume(throwing: CityBridgesMetaDataError.noRecords)
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
