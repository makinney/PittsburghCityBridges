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
    @Namespace var animation
    @State var dragOffset: CGSize = .zero
    @State var imageOffset: CGSize = .zero
    @State var imageScale: CGFloat = 1.0
    @State var bridgeImageOnly = false
    
    var bridgeModel: BridgeModel
    let buttonCornerRadius: CGFloat = 5
    let imageCornerRadius: CGFloat = 10
    var imageLoader: UIImageLoader = UIImageLoader()
    let imageSmallestMagnification = 1.0
    
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
                if self.bridgeImageOnly {
                    self.dragOffset = $0.translation
                }
            }
    }
    
    var magGesture: some Gesture {
        MagnificationGesture()
            .onChanged { newValue in
                self.imageScale = max(newValue, imageSmallestMagnification)
            }
    }
    
    var tapGesture: some Gesture {
        TapGesture(count: 1)
            .onEnded{
                self.bridgeImageOnly = true
            }
    }
    
    var body: some View {
        VStack {
            if bridgeImageOnly {
                VStack {
                    BridgeImageView(bridgeModel.imageURL)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(imageCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: imageCornerRadius)
                                .stroke(Color.secondary, lineWidth: 2.5)
                        )
                        .scaleEffect(imageScale)
                        .animation(.easeInOut, value: imageScale)
                        .offset(totalOffset(offset: imageOffset, by: dragOffset))
                        .animation(.easeInOut, value: dragOffset)
                        .gesture(magGesture.simultaneously(with: dragGesture))
                        .matchedGeometryEffect(id: "BridgeView", in: animation)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    self.bridgeImageOnly = false
                                    self.imageScale = 1.0
                                    self.dragOffset = .zero
                                }
                                .padding(.trailing, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                            }
                        }
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
            } else {
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Text("\(bridgeModel.name)")
                                .font(.headline)
                            BridgeImageView(bridgeModel.imageURL)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(imageCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: imageCornerRadius)
                                        .stroke(Color.secondary, lineWidth: 2.5)
                                )
                                .scaleEffect(imageScale)
                                .clipped()
                                .animation(.easeInOut, value: imageScale)
                                .gesture(magGesture)
                                .gesture(tapGesture)
                                .matchedGeometryEffect(id: "BridgeView", in: animation)
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
                        .padding(.horizontal)
                    }
                }
                .onAppear {
                    UIScrollView.appearance().bounces = true
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            }
        }
        .animation(.default, value: bridgeImageOnly)
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
