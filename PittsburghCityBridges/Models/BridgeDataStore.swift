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
    func loadFromNetwork() {
        let openDataAddress = "https://data.wprdc.org/dataset/d6e6c012-45f0-4e13-ab3b-9458fd56ad96/resource/c972b2cc-8396-4cd0-80d6-3051497da903/download/bridges_img.geojson"
        guard let url = URL(string: openDataAddress) else {
            return
        }
        
        Task {
            do {
                let decoder = JSONDecoder()
                let (data, urlResponse) = try await URLSession.shared.data(from: url)
        //        print("URLResponse \(urlResponse.debugDescription)")
                cityBridges = try decoder.decode(CityBridges.self, from: data)
                bridges = cityBridges.bridges
         //       print(cityBridges)
            } catch let error {
                print(error)
            }
        }
    }
}
