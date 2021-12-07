//
//  ImageViewLoader.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/22/21.
//

import Combine
import Files
import SwiftUI
import os
import UIKit

//struct BridgeView: View {
//    @ObservedObject private var imageLoader: UIImageLoader
//    
//    var imageURL: URL?
//    
//    init(imageLoader: UIImageLoader, imageURL: URL?) {
//        self.imageURL = imageURL
//        self.imageLoader = imageLoader
//    }
//    
//    var body: some View {
//        switch imageLoader.state {
//        case .idle:
//            Color.clear
//                .onAppear {
//                    imageLoader.loadBridgeImage(for: imageURL)
//                }
//        case .loading:
//            HStack {
//                Spacer()
//                ProgressView()
//                Spacer()
//            }
//        case .failed(let error):
//            Text(error)
//        case .loaded(let image):
//            Image(uiImage: image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//        }
//    }
//}

class UIImageLoader: ObservableObject {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    let fileServices: FileServices
    
    enum State {
        case idle
        case loading
        case failed(String)
        case loaded(UIImage)
    }
    
    init() {
        do {
            try fileServices = FileServices()
        } catch {
            fatalError("failed to create file services \(error.localizedDescription)")
        }
    }
    
    @Published private(set) var state = State.idle
    @Published private(set) var uiBridgeImage = UIImage()
    @MainActor
    func loadBridgeImage(for imageURL: URL?) {
        Task {
            do {
                guard let imageURL = imageURL else {
                    state = .failed("missing image URL")
                    return
                }
                state = .loading
                
                // do we have the image already available on disk?
                // get the file name
                let imageFileName = imageFileName(imageURL)
                let existingImageFile: File?  = fileServices.getFile(imageFileName)
                // if it exists, get's it's data and use that
                if let existingImageFile = existingImageFile {
                    do {
                        let data = try existingImageFile.read()
                        if let uiImage = UIImage(data: data) {
                            // persist, e.g. cache this data for future use
                            // use file service
                            // then update state with new image
                            state = .loaded(uiImage)
                            self.uiBridgeImage = uiImage
                        } else {
                            state = .failed("no Image for \(imageURL)")
                        }
                        return // TODO: ok to just return like this from inside a Task?
                    } catch {
                        logger.error("\(#file) \(#function) \(error.localizedDescription)")
                    }
                }
                
                // if it doesn't exist, request the data using the url
                
                let (data, response) = try await URLSession.shared.data(from: imageURL)
                logger.info("\(response.debugDescription)")
                // create a file if need be for this data
                // persist, e.g. cache this data for future use
                if existingImageFile == nil {
                    fileServices.createFile(imageFileName, data: data)
                }
                if let uiImage = UIImage(data: data) {
                    // then update state with new image
                    state = .loaded(uiImage)
                    self.uiBridgeImage = uiImage
                } else {
                    state = .failed("no Image for \(imageURL)")
                }
            } catch let error {
                logger.error("\(error.localizedDescription)")
                state = .failed(error.localizedDescription)
            }
        }
    }
    
    private func imageFileName(_ imageURL: URL) -> String {
        if let name = imageURL.pathComponents.last {
            return name
        } else {
            logger.info("\(#file) \(#function) error no file name for imageURL \(imageURL.debugDescription) ")
            return ""
        }
    }
}

/* usage
 
 var imageLoader: UIImageLoader = UIImageLoader()
 
 BridgeImageView(imageLoader: imageLoader, imageURL: bridgeModel.imageURL)
 .padding()
 .frame(minHeight: 100)
 .clipped()
 
 
 */

