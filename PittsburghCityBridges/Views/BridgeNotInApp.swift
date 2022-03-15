//
//  FernHollowSearch.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/10/22.
//

import SwiftUI

private struct MissingBridgeEvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
extension EnvironmentValues {
    var missingBridge: Bool {
        get { self[MissingBridgeEvironmentKey.self] }
        set {
            self[MissingBridgeEvironmentKey.self] = newValue
        }
    }
}
extension View {
    func missingBridge(_ missing: Bool) -> some View {
        environment(\.missingBridge, missing)
    }
}

enum BridgeMissing {
    case undefined
    case present
    case missing
}

class  BridgeNotInApp: ObservableObject {
    @Published var missingBridge = false
    func isFernHollowBridge(_ searchText: String) -> Bool {
        if "Fern Hollow".localizedCaseInsensitiveContains(searchText) {
            missingBridge = true
            return true
        }
        missingBridge = false
        return false
    }
    
    func setBridge(missing: Bool) {
        missingBridge = missing
    }
}
