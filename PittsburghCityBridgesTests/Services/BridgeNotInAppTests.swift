//
//  BridgeNotInAppTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/1/22.
//

import XCTest
@testable import PittsburghCityBridges

class BridgeNotInAppTests: XCTestCase {
     let bridgeNotInApp = BridgeNotInApp()
    
    func testFernHollow() {
        var searchText = "Golden Gate Bridge"
        var searchResult = bridgeNotInApp.isFernHollowBridge(searchText)
        XCTAssertFalse(searchResult)
        searchText = "Fern Hollow"
        searchResult = bridgeNotInApp.isFernHollowBridge(searchText)
        XCTAssertTrue(searchResult)
    }

}
