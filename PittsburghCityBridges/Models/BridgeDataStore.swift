//
//  BridgeStore.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/3/21.
//

import Foundation

class BridgeDataStore: ObservableObject {
    private var cityBridges: CityBridges = CityBridges()
    @Published var bridges: [Bridge] = []

    func loadFromResourceFile() {
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
    
    @MainActor
    func loadFromNetwork(openDataURL: String) {
        guard let url = URL(string: openDataURL) else {
            return
        }
        
        Task {
            do {
                let decoder = JSONDecoder()
                let (data, urlResponse) = try await URLSession.shared.data(from: url)
                print("URLResponse \(urlResponse.debugDescription)")
                cityBridges = try decoder.decode(CityBridges.self, from: data)
                bridges = cityBridges.bridges
            } catch let error {
                print(error)
            }
        }
    }
}
