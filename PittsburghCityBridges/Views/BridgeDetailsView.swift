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
    @Namespace private var bridgeAnimations
    @State private var bridgeImageOnly = false
    @State private var dragOffset: CGSize = .zero
    @State private var imageScale: CGFloat = 1.0
    @State private var startingOffset: CGSize = .zero
    
    var bridgeModel: BridgeModel
    private let buttonCornerRadius: CGFloat = 5
    private let imageCornerRadius: CGFloat = 10
    private let imageSmallestMagnification = 1.0
    private let logger =  Logger(subsystem: AppLogging.subsystem, category: AppLogging.debugging)
    
    private func totalOffset(offset: CGSize, by: CGSize) -> CGSize {
        let total = CGSize(width: offset.width + by.width, height: offset.height + by.height)
        Print("totalOffset total \(total) for offset \(offset) by \(by)")
        return total
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
    
    var body: some View {
        VStack {
            if bridgeImageOnly {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Spacer()
                        BridgeImageView(bridgeModel.imageURL)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(imageCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: imageCornerRadius)
                                    .stroke(Color.clear, lineWidth: 4)
                            )
                            .frame(maxWidth: geometry.frame(in: .global).width, maxHeight: geometry.frame(in: .global).height)
                            .scaleEffect(imageScale)
                            .animation(.easeInOut, value: imageScale)
                            .offset(dragOffset)
                            .animation(.easeInOut, value: dragOffset)
                            .clipped()
                            .gesture(magGesture.simultaneously(with: dragGesture))
                            .matchedGeometryEffect(id: "BridgeView", in: bridgeAnimations)
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
                        Spacer()
                        Print("Geometry frame \(geometry.frame(in: .global))")
                    }
                }
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
                            Text("\(bridgeModel.name)")
                                .font(.headline)
                            BridgeImageView(bridgeModel.imageURL)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(imageCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: imageCornerRadius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                                .scaleEffect(imageScale)
                                .animation(.easeInOut, value: imageScale)
                                .clipped()
                                .gesture(magGesture)
                                .gesture(
                                    TapGesture(count: 1)
                                        .onEnded{
                                            self.bridgeImageOnly = true
                                            self.startingOffset = .zero
                                        }
                                )
                                .matchedGeometryEffect(id: "BridgeView", in: bridgeAnimations)
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
