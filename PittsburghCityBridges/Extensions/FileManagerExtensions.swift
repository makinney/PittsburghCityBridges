//
//  FileManagerExtensions.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/4/21.
//

import Foundation

extension FileManager {
    static var cachesDirectoryURL: URL {
        `default`.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    static var documentsDirectoryURL: URL {
      `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
