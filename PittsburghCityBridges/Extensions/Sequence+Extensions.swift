//
//  Sequence+Extensions.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/29/21.
//  Based on work by John Sundell

import Foundation

extension Sequence {
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] {
        sorted { a, b in
            comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
