//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import os

struct BridgeDetailsView: View {
    @ObservedObject var favorites: Favorites
    @State private var showBridgeZoomableView = false
    @State var bridgeImage = UIImage()
    @State private var bridgeImageLoaded = false
    @State private var dragOffset: CGSize = .zero
    @State private var imageScale: CGFloat = 1.0
    @State private var imageMagnification: CGFloat = 1.0
    @State private var initialDragOffset: CGSize = .zero
    @State private var showDisclaimerSheet = false
    @Namespace private var bridgeAnimations
    
    var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let imageCornerRadius: CGFloat = 10
    private let imageSmallestMagnification = 1.0
    private let userInterfaceIdiom: UIUserInterfaceIdiom
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    init(bridgeModel: BridgeModel, favorites: Favorites) {
        self.bridgeModel = bridgeModel
        bridgeImageSystem = BridgeImageSystem()
        self.favorites = favorites
        self.userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                if self.showBridgeZoomableView {
                    self.dragOffset = self.totalOffset(offset: self.initialDragOffset, by: $0.translation)
                }
            }
            .onEnded { value in
                self.initialDragOffset = CGSize(width: self.initialDragOffset.width + value.translation.width,
                                                height: self.initialDragOffset.height + value.translation.height)
            }
    }
    
    private var magGesture: some Gesture {
        MagnificationGesture()
            .onChanged { newValue in
                self.imageScale = max(imageMagnification * newValue, imageSmallestMagnification)
            }
            .onEnded { value in
                self.imageMagnification = imageScale
            }
    }
    
    private var dblTapToZoomInGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                self.imageMagnification = imageScale
                self.imageScale *= 2.0
            }
    }
    
    var body: some View {
        VStack {
            if showBridgeZoomableView {
                bridgeZoomableView()
            } else {
                bridgeInfoWithMapView()
            }
        }
        .sheet(isPresented: $showDisclaimerSheet,
               content: {
            DirectionsDisclaimerView { userAcceptedDisclaimer in
                if userAcceptedDisclaimer,
                   let locationCoordinate = bridgeModel.locationCoordinate {
                    DirectionsProvider.shared.requestDirectionsTo(locationCoordinate)
                }
            }
            .background(Color.pbBgnd)
        })
        .task {
            do {
                if let image = await bridgeImageSystem.getImage(url: bridgeModel.imageURL)  {
                    bridgeImage = image
                    bridgeImageLoaded = true
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(bridgeModel.name)")
        .background(Color.pbBgnd)
        .animation(.default, value: showBridgeZoomableView)
    }
    
    private func bridgeInfoWithMapView() -> some View {
        return GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Image(systemName: "plus.magnifyingglass")
                                .imageScale(.large)
                            Text("Zoom")
                            Spacer()
                        }
                        .foregroundColor(.accentColor)
                        .padding(.top, 10)
                        HStack {
                            ZStack {
                                Image(uiImage: bridgeImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(PCBImage.cornerRadius)
                                    .background (
                                        RoundedRectangle(cornerRadius: PCBImage.cornerRadius)
                                            .stroke(Color.pbTextFnd, lineWidth: 4)
                                    )
                                    .padding(2)
                                    .frame(maxWidth: geometry.frame(in: .global).width, minHeight: 100)
                                    .matchedGeometryEffect(id: "BridgeView", in: bridgeAnimations)
                                    .opacity(bridgeImageLoaded ? 1.0 : 0.0)
                                    .gesture(magGesture)
                                BridgeImageLoadingProgressView(bridgeName: bridgeModel.name)
                                    .opacity(bridgeImageLoaded ? 0.0 : 1.0)
                            }
                        }
                    }
                    .padding([.bottom], 5)
                    .gesture(
                        TapGesture(count: 1)
                            .onEnded{
                                self.showBridgeZoomableView = true
                            }
                    )
                    Text(bridgeModel.builtHistory())
                        .padding([.bottom], 5)
                    Text(bridgeModel.neighborhoods())
                    HStack {
                        makeMapView(bridgeModel)
                            .frame(height: (userInterfaceIdiom == .phone) ? 200 : 250)
                    }
                }
                .foregroundColor(Color.pbTextFnd)
            }
            .padding([.leading, .trailing])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoritesButton(favorites, favorite: bridgeModel.name)
                        .padding(.trailing, 10)
                }
            }
            .background(Color.pbBgnd)
        }
        .font(.body)
        .background(Color.pbBgnd)
        .onAppear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    private func bridgeZoomableView() -> some View {
        return GeometryReader { geometry in
            VStack(alignment: .center) {
                Image(uiImage: bridgeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "BridgeView", in: bridgeAnimations)
                    .frame(maxWidth: geometry.frame(in: .global).width, maxHeight: geometry.frame(in: .global).height)
                    .scaleEffect(imageScale)
                    .animation(.easeInOut, value: imageScale)
                    .offset(dragOffset)
                    .animation(.easeInOut, value: dragOffset)
                    .gesture(magGesture.simultaneously(with: dragGesture))
                    .gesture(dblTapToZoomInGesture)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                self.dragOffset = .zero
                                self.initialDragOffset = .zero
                                self.imageScale = 1.0
                                self.imageMagnification = 1.0
                                self.showBridgeZoomableView = false
                            }
                        }
                    }
                Spacer()
            }
        }
        .background(Color.pbBgnd)
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    private func makeMapView(_ bridgeModel: BridgeModel) -> some View {
        ZStack {
            BridgeMapUIView(region: MapViewModel.singleBridgeRegion, bridgeModels: [bridgeModel], showsBridgeImage: false)
                .cornerRadius(PCBImage.cornerRadius)
                .background (
                    RoundedRectangle(cornerRadius: PCBImage.cornerRadius)
                        .stroke(Color.pbTextFnd, lineWidth: 4)
                )
                .padding(.horizontal,2)
            VStack {
                HStack {
                    if let _ = bridgeModel.locationCoordinate {
                        Button {
                            self.showDisclaimerSheet = true
                        } label: {
                            Label("Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                                .padding(.leading, 6)
                                .padding(.trailing, 10)
                                .padding(.vertical, 8)
                                .foregroundColor(.accentColor)
                                .background(Color.pbBgnd)
                        }
                        .cornerRadius(PCBButton.cornerRadius)
                        .background (
                            RoundedRectangle(cornerRadius: PCBButton.cornerRadius)
                                .stroke(Color.pbTextFnd, lineWidth: 4)
                        )
                        .padding()
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
    
    private func totalOffset(offset: CGSize, by: CGSize) -> CGSize {
        CGSize(width: offset.width + by.width, height: offset.height + by.height)
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    @ObservedObject static var favorites = Favorites()
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview, favorites: favorites)
        BridgeDetailsView(bridgeModel: BridgeModel.preview, favorites: favorites)
            .preferredColorScheme(.dark)
    }
}
