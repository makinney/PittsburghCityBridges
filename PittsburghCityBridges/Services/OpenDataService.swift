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
    let openDataFileSystem: OpenDataFileSystem
    private let bridgeModelsFileName = "cityBridgesOpenData"
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)

    init(container: CKContainer = CKContainer.default()) {
        self.container = container
        self.openDataFileSystem = OpenDataFileSystem()
    }
    
    func loadBridgeModelOpenData() async -> Data? {
        let bridgeModelData = await openDataFileSystem.getBridgeModedDataFromDisc(fileName: bridgeModelsFileName)
        return bridgeModelData
    }
    
    func downLoadBridgeModelOpenData() async {
        let url = await getCityBridgeOpenDataURL()
        if let url = url {
            if let data = await openDataFileSystem.getDataFrom(url: url) {
                openDataFileSystem.saveToDisk(fileName: bridgeModelsFileName, data: data)
                logger.info("\(#file) \(#function) updated json data file from open data server at url \(url)")
            }
        }
    }
    
    private func getCityBridgeOpenDataURL() async -> URL? {
        var cityBridgeOpenDataURL: URL?
        if let metaData = await getOpenDataMetaData() {
            let urlPath = metaData.cityBridgeOpenDataURL
            let url = URL(string: urlPath)
            guard let url = url else {
                logger.error("\(#file) \(#function) Could not create URL from path \(urlPath, privacy: .public)")
                return nil
            }
            cityBridgeOpenDataURL = url
        }
        return cityBridgeOpenDataURL
    }
    
    private func getOpenDataMetaData() async -> CloudKitCityBridgeAppMaintenanceData? {
        var metaData: CloudKitCityBridgeAppMaintenanceData?
        do {
             metaData = try await fetchCloudKitAppMaintenanceData()
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return metaData
    }
    
    private func fetchCloudKitAppMaintenanceData() async throws -> CloudKitCityBridgeAppMaintenanceData {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudKitCityBridgeAppMaintenanceData.recordType, predicate: predicate)
        let database = CKContainer.default().publicCloudDatabase
        let records = try await database.records(matching: query)
            .matchResults.map { try $1.get() } // Result<CKRecord, Error>
        if let record = records.first {
            return CloudKitCityBridgeAppMaintenanceData(record: record)
        } else {
            fatalError("\(#file) \(#function) failed to fetch city bridges meta data")
        }
    }
}

class CloudKitCityBridgeAppMaintenanceData {
    let title = "City of Pittsburgh Bridges"
    private(set) var cityBridgeOpenDataURL: String = ""
    private(set) var updated: Date = Date.distantPast
    private let recordID: CKRecord.ID
    static let recordType = "CityBridgesMetaData"
    init(record: CKRecord) {
        recordID = record.recordID
        cityBridgeOpenDataURL = record["geoJSONURL"] as? String ?? ""
    }
}
