//
//  BridgeDetailsView.swift
//  PittsburghCityBridges
//
//  Created by MAKinney on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import os

struct BridgeDetailsView: View {
    @State var dragOffset: CGSize = .zero
    @State var imageOffset: CGSize = .zero

    @State var fadeOtherViews = false
    @State var imageScale: CGFloat = 1.0
    @State var stickyDragAndMagMode = false

    var bridgeModel: BridgeModel
    let buttonCornerRadius: CGFloat = 5
    let imageCornerRadius: CGFloat = 10
    var imageLoader: UIImageLoader = UIImageLoader()
    let imageSmallestMagnification = 1.0

    private func resetImageLocation() {
        dragOffset = .zero
        imageOffset = .zero
        imageScale = 1.0
    }

    let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)

    private func totalOffset(by: CGSize) -> CGSize {
        let total = CGSize(width: imageOffset.width + by.width, height: imageOffset.height + by.height)
        Print("totalOffset total \(total) for offset \(imageOffset) by \(by)")
        return total
    }
    
    private func totalOffset(offset: CGSize, by: CGSize) -> CGSize {
        let total = CGSize(width: offset.width + by.width, height: offset.height + by.height)
        Print("totalOffset total \(total) for offset \(offset) by \(by)")
        return total
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                self.dragOffset = $0.translation
                self.fadeOtherViews = true // so background view fades without having to first tap image
            }
    }
    
    var magGesture: some Gesture {
        MagnificationGesture()
            .onChanged { newValue in
                self.imageScale = max(newValue, imageSmallestMagnification)
//                self.fadeOtherViews = true // so background view fades without having to first tap image
            }
    }
    
    var dragAndMagGesture: some Gesture {
        SimultaneousGesture(dragGesture, magGesture)
        .onEnded { value in
            if !self.stickyDragAndMagMode {
                self.resetImageLocation()
                self.fadeOtherViews = false
            }
        }
    }
    
    var tapGesture: some Gesture {
        TapGesture(count: 1)
        .onEnded{
            withAnimation(.easeIn){
                self.stickyDragAndMagMode = true
                self.imageOffset = CGSize(width: 0, height: 100)
                self.imageScale = 1.2
                self.fadeOtherViews = true
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("\(bridgeModel.name)")
                        .font(.headline)
                        .opacity(fadeOtherViews ? 0.0 : 1.0)
                    BridgeImageView(bridgeModel.imageURL)
                        .aspectRatio(contentMode: .fit)
           
                        .cornerRadius(imageCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: imageCornerRadius)
                                .stroke(Color.secondary, lineWidth: 2.5)
                        )
                        .scaleEffect(imageScale)
                        .if (!stickyDragAndMagMode) { view in
                            view.clipped()
                        }
                        .animation(.easeInOut, value: imageScale)
                        .offset(totalOffset(offset: imageOffset, by: dragOffset))
                        .animation(.easeInOut, value: dragOffset)
                        .gesture(dragAndMagGesture)
                        .gesture(tapGesture)
                    
                    VStack(alignment: .leading) {
                        Text(bridgeModel.builtHistory())
                            .padding(.top, 2)
                            .padding(.bottom)
                        Text(bridgeModel.neighborhoods())
                        makeMapView(bridgeModel)
                            .frame(height: 200)
                            .cornerRadius(imageCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: imageCornerRadius)
                                    .stroke(Color.secondary, lineWidth: 2)
                            )
                    }
                    .opacity(fadeOtherViews ? 0 : 1)
                }
                .padding(.horizontal)
                .animation(.easeInOut, value: fadeOtherViews)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        self.stickyDragAndMagMode = false
                        self.fadeOtherViews = false
                        self.resetImageLocation()
                    }
                    .padding(.trailing, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: buttonCornerRadius)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    .opacity(stickyDragAndMagMode ? 1 : 0)
                }
            }
        }
        .onAppear() {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
    
    func makeMapView(_ bridgeModel: BridgeModel) -> some View {
        ZStack {
            BridgeMapUIView(region: MapViewModel.singleBridgeRegion, bridgeModels: [bridgeModel], showsBridgeImage: false)
            Spacer()
            VStack {
                HStack {
                    if let locationCoordinate = bridgeModel.locationCoordinate {
                        Spacer()
                        Button {
                            DirectionsService().requestDirectionsTo(locationCoordinate)
                        } label: {
                            Label("Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                                .padding(4)
                                .background(Color(white: 0.9))
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .padding()
                    }
                }
                Spacer()
            }
        }
    }
}

struct BridgeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeDetailsView(bridgeModel: BridgeModel.preview)
            .preferredColorScheme(.dark)
        //       BridgeDetailsView(bridgeModel: BridgeModel.preview)
    }
}
