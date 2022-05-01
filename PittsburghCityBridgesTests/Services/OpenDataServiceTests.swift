//
//  OpenDataServiceTests.swift
//  OpenDataServiceTests
//
//  Created by MAKinney on 4/29/22.
//

import XCTest
@testable import PittsburghCityBridges

class OpenDataServiceTests: XCTestCase {
    let openDataService = OpenDataService()
    let openDataFileSystem = OpenDataFileSystem()
    let testFileName = "someName"
    private let bridgeModelsFileName = "cityBridgesOpenData"

    func testLoadBridgeModelOpenDataFromFile() async {
        openDataFileSystem.deleteFileIfExists(named: bridgeModelsFileName)
        let expectedData = Data(capacity: 1)
        openDataFileSystem.saveToDisk(fileName: bridgeModelsFileName, data: expectedData)
        let savedData = await openDataService.loadBridgeModelOpenData()!
        XCTAssertNotNil(savedData, "failed to save data")
        XCTAssert(savedData.count == expectedData.count, "failed to retrive data from the file")
    }

    func testLoadBridgeModelOpenDataFromBundle() async {
        openDataFileSystem.deleteFileIfExists(named: bridgeModelsFileName)
        let bundledData = await openDataService.loadBridgeModelOpenData()!
        XCTAssertNotNil(bundledData, "failed to get bundled data")
        let expectedBundledDataCount = 140545
        XCTAssert(bundledData.count == expectedBundledDataCount, "bundled data size not as expected")
    }

    @MainActor func testCloudKitAccessAndDataDownLoad() async {
        openDataFileSystem.deleteFileIfExists(named: bridgeModelsFileName)
        await openDataService.downLoadBridgeModelOpenData()
        let downLoadedData = await openDataService.loadBridgeModelOpenData()!
        XCTAssertNotNil(downLoadedData, "failed to download any data")
        XCTAssert(downLoadedData.count > 0, "downloaded data is empty")
    }
}
