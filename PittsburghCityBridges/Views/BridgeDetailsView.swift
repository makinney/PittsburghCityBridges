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
    @State private var bridgeImageOnly = false
    @State var bridgeImage = UIImage()
    @State private var dragOffset: CGSize = .zero
    @State private var imageScale: CGFloat = 1.0
    @State private var bridgeImageLoaded = false
    @State private var startingOffset: CGSize = .zero
    @Namespace private var bridgeAnimations
    
    var pbColorPalate = PBColorPalate()
    var bridgeModel: BridgeModel
    private var bridgeImageSystem: BridgeImageSystem
    private let buttonCornerRadius: CGFloat = 5
    private let imageCornerRadius: CGFloat = 10
    private let imageSmallestMagnification = 1.0
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    private func totalOffset(offset: CGSize, by: CGSize) -> CGSize {
        CGSize(width: offset.width + by.width, height: offset.height + by.height)
    }
    
    init(bridgeModel: BridgeModel, pbColorPalate: PBColorPalate, favorites: Favorites) {
        self.bridgeModel = bridgeModel
        self.pbColorPalate = pbColorPalate
        bridgeImageSystem = BridgeImageSystem()
        self.favorites = favorites
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                if self.bridgeImageOnly {
                    self.dragOffset = self.totalOffset(offset: self.startingOffset, by: $0.translation)
                }
            }
            .onEnded { value in
                self.startingOffset = CGSize(width: self.startingOffset.width + value.translation.width,
                                             height: self.startingOffset.height + value.translation.height)
            }
    }
    
    var magGesture: some Gesture {
        MagnificationGesture()
            .onChanged { newValue in
                self.imageScale = max(newValue, imageSmallestMagnification)
            }
    }
    
    var dblTapToZoomInGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                self.imageScale *= 2.0
            }
    }
    
    var body: some View {
        VStack {
            if bridgeImageOnly {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Image(uiImage: bridgeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(imageCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: imageCornerRadius)
                                    .stroke(Color.clear, lineWidth: 4)
                            )
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
                                        self.imageScale = 1.0
                                        self.startingOffset = .zero
                                        self.bridgeImageOnly = false
                                    }
                                    .padding(.trailing, 10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: buttonCornerRadius)
                                            .stroke(Color.secondary, lineWidth: 2)
                                    )
                                }
                            }
                        Spacer()
                    }
                }
                .background(pbColorPalate.textBgnd)
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            } else {
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            VStack {
                                HStack {
                                    Text("\(bridgeModel.name)")
                                        .font(.headline)
                                    VStack {
                                        Spacer()
                                        Image(systemName: "plus.magnifyingglass")
                                            .imageScale(.large)
                                            .foregroundColor(.accentColor)
                                    }
                                    Spacer()
                                }
                                HStack {
                                    ZStack {
                                        Image(uiImage: bridgeImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(imageCornerRadius)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: imageCornerRadius)
                                                    .stroke(Color.secondary, lineWidth: 2)
                                            )
                                            .matchedGeometryEffect(id: "BridgeView", in: bridgeAnimations)
                                            .frame(maxWidth: geometry.frame(in: .global).width, minHeight: 100)
                                            .scaleEffect(imageScale)
                                            .animation(.easeInOut, value: imageScale)
                                            .clipped()
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
                                        self.bridgeImageOnly = true
                                    }
                            )
                            Text(bridgeModel.builtHistory())
                                .padding([.bottom], 5)
                            Text(bridgeModel.neighborhoods())
                            HStack {
                                makeMapView(bridgeModel)
                                    .frame(height: 200)
                                    .cornerRadius(imageCornerRadius)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: imageCornerRadius)
                                            .stroke(Color.secondary, lineWidth: 2)
                                    )
                            }
                        }
                        .foregroundColor(pbColorPalate.textFgnd)
                    }
                    .padding([.leading, .trailing])
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            FavoritesButton(favorites, favorite: bridgeModel.name)
                                .padding(.trailing, 10)
                        }
                    }
                    .background(pbColorPalate.textBgnd)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = true
                    Task {
                        do {
                            if let image = await bridgeImageSystem.getImage(url: bridgeModel.imageURL)  {
                                bridgeImage = image
                                bridgeImageLoaded = true
                            }
                        }
                    }
                    
                }
            }
        }
        .animation(.default, value: bridgeImageOnly)
    }
    
    func makeMapView(_ bridgeModel: BridgeModel) -> some View {
        ZStack {
            BridgeMapUIView(region: MapViewModel.singleBridgeRegion, bridgeModels: [bridgeModel], showsBridgeImage: false)
            VStack {
                HStack {
                    if let locationCoordinate = bridgeModel.locationCoordinate {
                        Button {
                            DirectionsProvider.shared.requestDirectionsTo(locationCoordinate)
                        } label: {
                            Label("Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                                .padding(4)
                                .foregroundColor(.accentColor)
                                .background(Color.pbTitleTextBgnd)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .padding()
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    @ObservedObject static var favorites = Favorites()
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview, pbColorPalate: PBColorPalate(), favorites: favorites)
        //         .preferredColorScheme(.dark)
        //        BridgeDetailsView(bridgeModel: BridgeModel.preview, pbColorPalate: PBColorPalate())
        //            .environmentObject(FavoriteBridges())
        
    }
}
