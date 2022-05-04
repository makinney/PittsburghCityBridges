//
//  BridgeModelTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/3/22.
//

import XCTest
@testable import PittsburghCityBridges
import MapKit

class BridgeModelTests: XCTestCase {

    var bridgeModel: BridgeModel!
    let bridgeName = "Charles Anderson Bridge"
    let startNeighborhood = "Squirrel Hill South"
    let endNeighborhood = "South Oakland"
    let built = "1900"
    let rehabbed = "1960"
    override func setUpWithError() throws {
        bridgeModel = buildBridgeModel()
    }

    func testBridgeModel() {
        XCTAssertTrue(bridgeModel.name == bridgeName, "bridge name expected \(bridgeName) received \(bridgeModel.name)")
        XCTAssertTrue(bridgeModel.imageURL == nil, "imageURL expected nil received \(String(describing: bridgeModel.imageURL))")
        XCTAssertTrue(bridgeModel.yearBuilt == built, "year built expected \(built) received \(bridgeModel.yearBuilt)")
        XCTAssertTrue(bridgeModel.yearRehab == rehabbed, "year rehabbed expected \(rehabbed) received \(bridgeModel.yearRehab)")
        XCTAssertTrue(bridgeModel.startNeighborhood == startNeighborhood, "start neighborhood expected \(startNeighborhood) received \(bridgeModel.startNeighborhood)")
        XCTAssertTrue(bridgeModel.endNeighborhood == endNeighborhood, "end neighborhood expected \(endNeighborhood) received \(bridgeModel.endNeighborhood)")
        XCTAssertTrue(bridgeModel.polylines.count == 1, "expected 1 polyline received \(bridgeModel.polylines.count)")
    }

    func testBridgeModelExtensions() {
        let expectedHistory = "Year Built: \(built) \nRehabbed: \(rehabbed)"
        XCTAssertTrue(bridgeModel.builtHistory() == expectedHistory, "built history expected \(expectedHistory) received \(bridgeModel.builtHistory())")
        let expectedNeighborhoods = "Neighborhood: \(startNeighborhood) and runs to \(endNeighborhood)"
        XCTAssertTrue(bridgeModel.neighborhoods() == expectedNeighborhoods, "neighborhoods expected \(expectedNeighborhoods) received \(bridgeModel.neighborhoods())")
        XCTAssertTrue(bridgeModel.refurbished() == rehabbed, "year rehabbed expected \(rehabbed) received \(bridgeModel.refurbished())")
  }
}

extension BridgeModelTests {
    func buildBridgeModel() -> BridgeModel {
        return {
            let openDataID: Int = 123456
            let imagePath: String? = nil
            let property = GeoJSONProperty(openDataID: openDataID, yearBuilt: built, name: bridgeName, yearRehab: rehabbed, imagePath: imagePath, startNeighborhood: startNeighborhood, endNeighborhood: endNeighborhood)
            var geometry =  [MKShape & MKGeoJSONObject]()
            let startPoint = CLLocationCoordinate2D(latitude: 40.43423858438876, longitude: -79.95168694309808)
            let endPoint = CLLocationCoordinate2D(latitude: 40.43458973277687, longitude: -79.94857558064106)
            var polyCoordinates = [CLLocationCoordinate2D]()
            polyCoordinates.append(startPoint)
            polyCoordinates.append(endPoint)
            let polyline: MKPolyline = MKPolyline(coordinates: polyCoordinates)
            geometry.append(polyline)
            return BridgeModel(geometry: geometry, geoJSON: property)
        }()
    }
}
