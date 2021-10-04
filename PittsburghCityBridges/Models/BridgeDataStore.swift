//
//  BridgeStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation
import Combine

class BridgeDataStore: ObservableObject {
    @Published var cityBridges: CityBridges = CityBridges()
    @Published var bridges: [Bridge] = []

    func load() {
        guard let url = Bundle.main.url(forResource: "BridgesOpenData", withExtension: "json") else {
            return
        }
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            cityBridges = try decoder.decode(CityBridges.self, from: data)
            bridges = cityBridges.bridges
            print(cityBridges)
        } catch let error {
            print(error)
        }
    }
}
