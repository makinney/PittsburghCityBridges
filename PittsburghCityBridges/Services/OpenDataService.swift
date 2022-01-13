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
    let openDataFileSystem: OpenDataFileSystem
    private let localJSONFileName = "BridgesJSON"

    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)

    var openDataURL: String {
        get async throws {
            try await fetchMetaData().geoJSONURL
        }
    }
    
    var serverURL: URL? {
        get async {
            await getBridgeDataBaseURL()
        }
    }

    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        self.openDataFileSystem = OpenDataFileSystem()
        publicDB = container.publicCloudDatabase
    }
    
    func getBridgesJSON() async -> Data? {
        let data = await openDataFileSystem.getJSONBridgeDataFromCached(fileName: localJSONFileName)
        Task {
            await manageSavedJSONData()
        }
        return data
    }
    
    private func getMetaData() async -> OpenDataMetaData? {
        // thread running
        var metaData: OpenDataMetaData?
        do {
             metaData = try await fetchMetaData()
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return metaData
    }
    
    private func getBridgeDataBaseURL() async -> URL? {
        var url: URL?
        if let metaData = await getMetaData() {
            let urlPath = metaData.geoJSONURL
            url = URL(string: urlPath)
            if url == nil{
                logger.error("\(#file) \(#function) Could not create URL from path \(urlPath, privacy: .public)")
            }
        }
        return url
    }
    
    private func manageSavedJSONData() async {
        let savedData: Data? = openDataFileSystem.readSavedFileData(fileName: localJSONFileName)
        if savedData == nil,
           let url = await getBridgeDataBaseURL() {
            if let data = await openDataFileSystem.getDataFrom(url: url) {
                openDataFileSystem.saveToDisk(fileName: localJSONFileName, data: data)
                logger.info("\(#file) \(#function) got server json data")
            }
        } else {
            // existis, update if timing difference
        }
    }
    
    private func manageBridgeStore() {
        // if no file create file
    
        // use meta data
        // get meta data
        // compare meta database last updated date against local  file update date
        // update local saved data with what's on open data server
        
    }
  
    func fetchMetaData() async throws -> OpenDataMetaData {
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
