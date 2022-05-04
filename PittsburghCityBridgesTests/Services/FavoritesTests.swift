//
//  FavoritesTests.swift
//  PittsburghCityBridgesTests
//
//  Created by MAKinney on 5/1/22.
//

import XCTest
import SwiftUI

@testable import PittsburghCityBridges

@MainActor
class FavoritesTests: XCTestCase {
    let favoritesStore = FavoritesStore()
    
    func testAddElement() {
        let element = "abc"
        if favoritesStore.contains(element: element) {
            _ = favoritesStore.remove(element: element)
        }
        XCTAssertTrue(favoritesStore.add(element: element))
    }
    
    func testRemoveElement() {
        let element = "abc"
        if !favoritesStore.contains(element: element) {
            _ = favoritesStore.add(element: element)
        }
        XCTAssertTrue(favoritesStore.remove(element: element))
    }
    
    func testContainsElement() {
        let element = "abc"
        _ = favoritesStore.add(element: element)
        XCTAssertTrue(favoritesStore.contains(element: element))
        _ = favoritesStore.remove(element: element)
        XCTAssertFalse(favoritesStore.contains(element: element))
    }
  

}
