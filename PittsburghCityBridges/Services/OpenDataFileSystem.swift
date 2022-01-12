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
    private let cityBridgesCachedFileName = "CityBridges"
    
    
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
    
    func getBridgeJSONData(url: URL) async -> Data? {
 //       getCachedData(for: cityBridgesCachedFileName)
     
        let data = await getBundledCityBridgeJSON()
        return data
    }
    
    func getBundledCityBridgeJSON() async -> Data? {
        var data: Data?
        if let bundleFileURL = getBundledFileURL() {
            do {
                let (bundledData, _) = try await URLSession.shared.data(from: bundleFileURL)
                data = bundledData
            } catch let error {
                logger.error("\(#file) \(#function) \(error.localizedDescription, privacy: .public)")
            }
        } else {
            logger.error("\(#file) \(#function) no bundled JSON data")
        }
        return data
    }
    
    
    //                 let (data, _) = try await URLSession.shared.data(from: url)

    func getOpenData(for url: URL) async -> Data? {
        var data: Data?
        // use file in cache folder if we have it
        let fileName = getFileName(url)
        let cachedData: Data? = getData(for: fileName)
        if let cachedData = cachedData {
           data = cachedData
        } else {
            // use bundled
            data = await getBundledCityBridgeJSON()
        }
        // else use file in bundle
        
        // either way, update the cache folder file, either because it doesn't exist or the open data file on the server has updated
        
        return data
    }
    

    
    private func getData(for fileName: String) -> Data? {
        var data: Data?
        if let file = getFile(fileName) {
            do {
                data = try file.read()
            } catch {
                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
            }
        }
        return data
    }
    
    private func getBundledFileURL() -> URL? {
        return Bundle.main.url(forResource: "BridgesOpenData", withExtension: "json")
    }
    
    private func getFile(_ named: String) -> File? {
        var file: File?
        do {
            file = try openDataFolder?.file(named: named)
        } catch {
            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
        }
        return file
    }
    
    
    private func getFileName(_ url: URL) -> String {
        if let name = url.pathComponents.last {
            return name
        } else {
            logger.info("\(#file) \(#function) error no file name for url \(url.debugDescription) ")
            return ""
        }
    }
    
    
//    private func saveToDisk(fileName: String, data: Data) {
//        var existingFile = getFile(fileName)
//        if existingFile == nil {
//            do {
//                existingFile = try bridgeImagesFolder?.createFile(named: fileName)
//            } catch {
//                logger.info("\(#file) \(#function) error \(error.localizedDescription)")
//                fatalError("\(#file) \(#function) could not create image file name \(fileName)")
//            }
//        }
//        do {
//            try existingFile?.write(data)
//        } catch {
//            logger.info("\(#file) \(#function) error \(error.localizedDescription)")
//            fatalError("\(#file) \(#function) could not create image file name \(fileName)")
//        }
//    }
    
}
