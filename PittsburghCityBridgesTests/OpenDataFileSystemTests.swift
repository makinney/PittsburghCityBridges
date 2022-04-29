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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetBridgeModedDataFromFileIsNil() {
        let data = openDataFileSystem.readData(fileName: "")
        XCTAssertNil(data)
    }
    
    func testCreateDiscFile() async {
        let fileName = "someFileName"
        openDataFileSystem.deleteFileIfExists(named: fileName)
        let bundledData = await openDataFileSystem.getBridgeModelDataFromBundle()!
        XCTAssertNotNil(bundledData, "Failed to get bundled data")
        openDataFileSystem.saveToDisk(fileName: fileName, data: bundledData)
        XCTAssertNotNil(openDataFileSystem.getFile(named: fileName), "failed to create file")
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
