//
//  BridgeNotInApp.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 3/10/22.
//

import SwiftUI

struct StateBridgesInPittsburgh {
    
    struct StateBridge: Identifiable {
        let name: String
        let id = UUID()
    }
    static let stateBridges: [StateBridge] = [StateBridge(name: "31st Street Bridge"),
                                              StateBridge(name: "40th Street Bridge"),
                                              StateBridge(name: "62nd Street Bridge"),
                                              StateBridge(name: "Andy Warhol Bridge"),
                                              StateBridge(name: "Birmingham Bridge"),
                                              StateBridge(name: "David McCullough Bridge"),
                                              StateBridge(name: "Fort Pitt Bridge"),
                                              StateBridge(name: "Glenwood Bridge"),
                                              StateBridge(name: "Highland Park Bridge"),
                                              StateBridge(name: "Homestead Grays Bridge"),
                                              StateBridge(name: "Liberty Bridge"),
                                              StateBridge(name: "McKees Rocks Bridge"),
                                              StateBridge(name: "Rachel Carson Bridge"),
                                              StateBridge(name: "Rankin Bridge"),
                                              StateBridge(name: "Roberto Clemente Bridge"),
                                              StateBridge(name: "Smithfield Bridge"),
                                              StateBridge(name: "Veterans Bridge")]
}

class  BridgeNotInApp: ObservableObject {
    @Published private(set) var missingBridge = false
    let fernHollowBridgeName = "Fern Hollow"
    func isFernHollowBridge(_ searchText: String) -> Bool {
        if  fernHollowBridgeName.localizedCaseInsensitiveContains(searchText) {
            missingBridge = true
            return true
        }
        missingBridge = false
        return false
    }
    
    func stateBridgeName(_ searchText: String) -> String? {
        var foundBridgeName: String?
        for stateBridge in StateBridgesInPittsburgh.stateBridges {
            if stateBridge.name.localizedCaseInsensitiveContains(searchText) {
                foundBridgeName = stateBridge.name
                break
            }
        }
        return foundBridgeName
    }
}


// Not presently used
private struct BridgeNotInAppEvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
extension EnvironmentValues {
    var missingBridge: Bool {
        get { self[BridgeNotInAppEvironmentKey.self] }
        set {
            self[BridgeNotInAppEvironmentKey.self] = newValue
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

