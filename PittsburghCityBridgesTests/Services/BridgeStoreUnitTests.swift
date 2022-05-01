//
//  BridgeStoreUnitTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/1/22.
//

import XCTest
@testable import PittsburghCityBridges

@MainActor
class BridgeStoreUnitTests: XCTestCase {

    let bridgeStore = BridgeStore()
    let openDataFileSystem = OpenDataFileSystem()
    private let bridgeModelsFileName = "cityBridgesOpenData"

    override func setUpWithError() throws {
        // ensure to use bundled data for bridge models
        openDataFileSystem.deleteFileIfExists(named: bridgeModelsFileName)
    }

    func testLoadBridgeModels() async {
        bridgeStore.clearBridgeModels()
        await bridgeStore.loadBridgeModels()
        let numBridges = 142
        XCTAssertTrue(bridgeStore.bridgeModels.count == numBridges)
    }
}
