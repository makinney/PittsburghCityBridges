//
//  OpenDataFileSystem.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 12/17/21.
//

import Foundation
import Files
import os

class OpenDataFileSystem: ObservableObject {
    private let openDataFolderName = "OpenData"
    private var openDataFolder: Folder?
    private (set)var cachesFolder: Folder?
    
    private let logger: Logger = Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init() {
        let cachesPath = FileManager.cachesDirectoryURL.path
        do {
            cachesFolder = try Folder(path: cachesPath)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            fatalError("\(#file) \(#function) could not create cachesFolder")
        }
        if let cachesFolder = cachesFolder {
            do {
                if !cachesFolder.containsSubfolder(named: openDataFolderName) {
                    openDataFolder = try cachesFolder.createSubfolder(named: openDataFolderName)
                } else {
                    openDataFolder = try cachesFolder.subfolder(named: openDataFolderName)
                }
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
                fatalError("\(#file) \(#function) could not create openDataFolder")
            }
        }
    }
    
    func getBridgeModedDataFromFile(named fileName: String) -> Data? {
        readData(fileName: fileName)
    }
    
    func getBridgeModelDataFromBundle() async -> Data? {
        var data: Data?
        if let bundleFileURL = getBundledFileURL() {
            data = await getDataFrom(url: bundleFileURL)
        }
        if data == nil {
            logger.error("\(#file) \(#function) no bundled JSON data")
        }
        return data
    }
    
    func getDataFrom(url: URL) async -> Data? {
        var data: Data?
        do {
            let (_data, _) = try await URLSession.shared.data(from: url)
            data = _data
        } catch let error {
            logger.error("\(#file) \(#function) \(error.localizedDescription, privacy: .public)")
        }
        return data
    }
    
    func saveToDisk(fileName: String, data: Data) {
        var existingFile = getFile(named: fileName)
        if existingFile == nil {
            do {
                existingFile = try openDataFolder?.createFile(named: fileName)
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
                fatalError("\(#file) \(#function) could not create image file name \(fileName)")
            }
        }
        do {
            try existingFile?.write(data)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            fatalError("\(#file) \(#function) could not create image file name \(fileName)")
        }
    }
    
    func getBundledFileURL() -> URL? {
        return Bundle.main.url(forResource: "BridgesOpenData", withExtension: "json")
    }
    
    private func readData(fileName: String) -> Data? {
        var data: Data?
        if let file = getFile(named: fileName) {
            do {
                data = try file.read()
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            }
        }
        return data
    }
    
    private func getFile(named: String) -> File? {
        var file: File?
        do {
            file = try openDataFolder?.file(named: named)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return file
    }
}

extension OpenDataFileSystem {
    // Unit Test Helper
    func deleteFileIfExists(named fileName: String) {
        if let file = getFile(named: fileName) {
            do {
                try file.delete()
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            }
        }
    }
}
