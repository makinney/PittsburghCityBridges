//
//  GEOJSONModelTest.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/3/22.
//

import XCTest
@testable import PittsburghCityBridges
class GEOJSONModelTest: XCTestCase {

    func testCodingKeys() {
        XCTAssertTrue(GeoJSONProperty.CodingKeys.openDataID.stringValue == "id", "openDataID failed")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.yearBuilt.stringValue == "year_built", "yearBuilt failed")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.name.stringValue == "name")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.yearRehab.stringValue == "year_rehab", "yearRehab failed")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.imagePath.stringValue == "image", "imagePath failed")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.startNeighborhood.stringValue == "start_neighborhood", "startNeighborhood failed")
        XCTAssertTrue(GeoJSONProperty.CodingKeys.endNeighborhood.stringValue == "end_neighborhood", "endNeighborhood failed")
    }
}
