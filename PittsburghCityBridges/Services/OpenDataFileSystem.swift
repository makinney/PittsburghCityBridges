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
    private let localJSONFileName = "BridgesJSON"
    
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
    
    func getBridges(url: URL?) async -> Data? {
        var data: Data?
        if let cachedData = readSavedFileData(fileName: localJSONFileName) {
            data = cachedData
        } else {
            data = await getBundledCityBridgeJSON()
        }
        Task {
            if let url = url {
                await manageSavedJSONData(serverURL: url)
            }
        }
        return data
    }
    
    private func manageSavedJSONData(serverURL: URL) async {
        let savedData: Data? = readSavedFileData(fileName: localJSONFileName)
        if savedData == nil {
            if let data = await getData(url: serverURL) {
                saveToDisk(fileName: localJSONFileName, data: data)
                logger.info("\(#file) \(#function) got server json data")
            }
        }
    }
    
    private func getData(url: URL) async -> Data? {
        var data: Data?
        do {
            let (_data, _) = try await URLSession.shared.data(from: url)
            data = _data
        } catch let error {
            logger.error("\(#file) \(#function) \(error.localizedDescription, privacy: .public)")
        }
        return data
    }
    
    private func getBundledCityBridgeJSON() async -> Data? {
        var data: Data?
        if let bundleFileURL = getBundledFileURL() {
            data = await getData(url: bundleFileURL)
        }
        if data == nil {
            logger.error("\(#file) \(#function) no bundled JSON data")
        }
        return data
    }
    
    private func getBundledFileURL() -> URL? {
        return Bundle.main.url(forResource: "BridgesOpenData", withExtension: "json")
    }
    
    private func getSavedFile(named: String) -> File? {
        var file: File?
        do {
            file = try openDataFolder?.file(named: named)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return file
    }
    
    private func readSavedFileData(fileName: String) -> Data? {
        var data: Data?
        if let file = getSavedFile(named: fileName) {
            do {
                data = try file.read()
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            }
        }
        return data
    }
    
    private func saveToDisk(fileName: String, data: Data) {
        var existingFile = getSavedFile(named: fileName)
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
    
}
