//
//  BridgeImageView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/25/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

struct BridgeImageView: View {
    let logger =  Logger(subsystem: AppLogging.subsystem, category: "BridgeImageView")
    var url: URL?
    var body: some View {
        return WebImage(url: url)
            .resizable()
            .indicator(.activity)
    }
    
    init(_ url: URL?) {
        self.url = url
        logger.info("opening image for url \(url?.path ?? "no url")")
    }
}

struct BridgeImageView_Previews: PreviewProvider {
    @ObservedObject static var bridgeStore = BridgeStore()
    static var previews: some View {
        BridgeImageView(bridgeStore.bridgeModels.first?.imageURL)
            .onAppear {
    //            bridgeStore.preview
            }
    }
}

public struct LazyReleaseableWebImage<T: View>: View {

    @State
    private var shouldShowImage: Bool = false

    private let content: () -> WebImage
    private let placeholder: () -> T

    public init(@ViewBuilder content: @escaping () -> WebImage,
                             @ViewBuilder placeholder: @escaping () -> T) {
        self.content = content
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack {
            if shouldShowImage {
                content()
            } else {
                placeholder()
            }
        }
        .onAppear {
            shouldShowImage = true
        }
        .onDisappear {
            shouldShowImage = false
        }
    }
}

struct Content: Identifiable {
    var id: Int { tag }
    let tag: Int
    let url: URL
}
