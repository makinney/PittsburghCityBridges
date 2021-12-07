//
//  FileServices.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/3/21.
//

import Foundation
import Files
import os

class FileServices: ObservableObject {
    private let bridgeImagesFolderName = "BridgeImages"
    private let bridgeImagesFolder: Folder
    private let cachesFolder: Folder
    
    let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    
    init() throws {
        let cachesPath = FileManager.cachesDirectoryURL.path
        cachesFolder = try Folder(path: cachesPath)
        if !cachesFolder.containsSubfolder(named: bridgeImagesFolderName) {
            bridgeImagesFolder = try cachesFolder.createSubfolder(named: bridgeImagesFolderName)
        } else {
            bridgeImagesFolder = try cachesFolder.subfolder(named: bridgeImagesFolderName)
        }
    }
    
    func getFile(_ named: String) -> File? {
        // check for existance
        var file: File?
        do {
            file = try bridgeImagesFolder.file(named: named)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return file
    }
    
    func createFile(_ named: String, data: Data) {
        do {
            try bridgeImagesFolder.createFile(named: named, contents: data)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
    }
}
