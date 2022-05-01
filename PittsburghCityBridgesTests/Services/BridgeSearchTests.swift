//
//  BridgeSearchTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/1/22.
//

import XCTest
import SwiftUI
@testable import PittsburghCityBridges

struct TestView: View {
    @EnvironmentObject var bridgeStore: BridgeStore
    var body: some View {
        Text("test")
    }
}

class BridgeSearchTests: XCTestCase {

 //   @StateObject var bridgeStore: BridgeStore = BridgeStore()
    var bridgeSearcher: BridgeSearcher!
    let bridgeModelsFileName = "cityBridgesOpenData"
    let openDataFileSystem = OpenDataFileSystem()
    
    override init() {
        super.init()
//        TestView()
 //           .environmentObject(bridgeStore)
    }
    override func setUpWithError() throws {
    //    bridgeSearcher = BridgeSearcher(bridgeStore)
        openDataFileSystem.deleteFileIfExists(named: bridgeModelsFileName)
    }

//    func testSortSearchNoSearchTextNoFavorites() {
//        bridgeSearcher = BridgeSearcher(bridgeStore)
//
//        var bridgeModelCategories = bridgeSearcher.sortAndSearch(by: .name)
//        XCTAssert(bridgeModelCategories.count > 0)
//    }
}
