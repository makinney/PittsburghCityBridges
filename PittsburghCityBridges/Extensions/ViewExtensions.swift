//
//  ViewExtensions.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 11/23/21.
//

import SwiftUI

extension View {
    @discardableResult
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v)}
        return EmptyView()
    }
}

extension View {
    /// Credit  to https://www.avanderlee.com/swiftui/conditional-view-modifier/
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
           if condition {
               transform(self)
           } else {
               self
           }
       }
}

