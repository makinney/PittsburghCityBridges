//
//  OpenDataFileSystemTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 4/29/22.
//


import XCTest
@testable import PittsburghCityBridges

class OpenDataFileSystemTests: XCTestCase {
    let openDataFileSystem = OpenDataFileSystem()
    let testFileName = "testFileName"
    
    func testCreateDataFile() async {
        let someData = Data()
        openDataFileSystem.saveToDisk(fileName: testFileName, data: someData)
        let savedData = openDataFileSystem.getBridgeModedDataFromFile(named: testFileName)
        XCTAssertNotNil(savedData, "failed to save data")
    }
    
    func testGetDataFromURL() async {
        let fileURL = openDataFileSystem.getBundledFileURL()!
        XCTAssertNotNil(fileURL, "failed to get bundle file URL")
        let data = await openDataFileSystem.getDataFrom(url: fileURL)
        XCTAssertNotNil(data, "failed to get date from URL")
    }
    
    func testGetBridgeModelDataFromBundle() async {
        let bundledData = await openDataFileSystem.getBridgeModelDataFromBundle()!
        XCTAssertNotNil(bundledData, "Failed to get bundled data")
    }
    
    func testGetBridgeModedDataFromFile() async {
        openDataFileSystem.deleteFileIfExists(named: testFileName)
        let expectedData = await openDataFileSystem.getBridgeModelDataFromBundle()!
        XCTAssertNotNil(expectedData, "Failed to get bundled data")
        openDataFileSystem.saveToDisk(fileName: testFileName, data: expectedData)
        let savedData = openDataFileSystem.getBridgeModedDataFromFile(named: testFileName)
        XCTAssertNotNil(savedData, "failed to save data")
        XCTAssertEqual(savedData, expectedData, "saved data does not equal expected data")
    }
}
