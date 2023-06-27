//
//  RangeSlider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 22.06.2023.
//

import SwiftUI
import Combine

@propertyWrapper
struct SliderValue {
    var value: Double
    
    init(wrappedValue: Double) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Double {
        get { value }
        set { value = min(max(0.0, newValue), 1.0) }
    }
}

final class SliderHandle: ObservableObject {
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    let sliderValueStart: Double
    let sliderValueRange: Double
    
    var diameter: CGFloat = 20
    var startLocation: CGPoint
    
    @Published var currentPercentage: SliderValue
    @Published var onDrag: Bool
    @Published var currentLocation: CGPoint
    
    init(sliderWidth: CGFloat, sliderHeight: CGFloat, minBound: Double, maxBound: Double, startPercentage: SliderValue) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = minBound
        self.sliderValueRange = maxBound - minBound
        
        let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue) / 1) * sliderWidth, y: sliderHeight / 2)
        
        self.startLocation = startLocation
        self.currentLocation = startLocation
        self.currentPercentage = startPercentage
        
        self.onDrag = false
    }
    
    lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>>  = DragGesture()
        .onChanged { value in
            self.onDrag = true
            
            let dragLocation = value.location
            
            self.restrictSliderBtnLocation(dragLocation)
            self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)
        }.onEnded { _ in
            self.onDrag = false
        }
    
    private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
        if dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth {
            calcSliderBtnLocation(dragLocation)
        }
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
        if dragLocation.y != sliderHeight / 2 {
            currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight/2)
        } else {
            currentLocation = dragLocation
        }
    }
    
    var currentValue: Double {
        return sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
    }
}

final class CustomSlider: ObservableObject {
    var width: CGFloat
    let lineWidth: CGFloat = 3.5
    
    let minBound: Double
    let maxBound: Double
    
    @Published var lowHandle: SliderHandle
    @Published var highHandle: SliderHandle
    
    @SliderValue private var lowHandleStartPercentage = 0.0
    @SliderValue private var highHandleStartPercentage = 1.0
    
    var anyCancellableHigh: AnyCancellable?
    var anyCancellableLow: AnyCancellable?
    
    init(minBound: Double, maxBound: Double, lowValue: Double, highValue: Double, width: CGFloat) {
        self.width = width
        
        self.minBound = minBound
        self.maxBound = maxBound
        
        let difference = maxBound - minBound
        let const = maxBound / difference
        let lowVal = lowValue - minBound
        let highVal = highValue - minBound
        
        let startPercentage = lowVal * const
        _lowHandleStartPercentage.wrappedValue = startPercentage / 100
        
        let endPercentage = highVal * const
        _highHandleStartPercentage.wrappedValue = endPercentage / 100
        
        lowHandle = SliderHandle(sliderWidth: width,
                                 sliderHeight: lineWidth,
                                 minBound: minBound,
                                 maxBound: maxBound,
                                 startPercentage: _lowHandleStartPercentage
        )
        
        highHandle = SliderHandle(sliderWidth: width,
                                  sliderHeight: lineWidth,
                                  minBound: minBound,
                                  maxBound: maxBound,
                                  startPercentage: _highHandleStartPercentage
        )
        
        anyCancellableHigh = highHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        
        anyCancellableLow = lowHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    var percentagesBetween: String {
        return String(format: "%.2f", highHandle.currentPercentage.wrappedValue - lowHandle.currentPercentage.wrappedValue)
    }
    
    var valueBetween: String {
        return String(format: "%.2f", highHandle.currentValue - lowHandle.currentValue)
    }
}

struct RangeSlider: View {
    @StateObject var slider: CustomSlider
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.lineWidth)
            .fill(Color.colorMediumGrey)
            .frame(width: slider.width, height: slider.lineWidth)
            .overlay(
                ZStack {
                    SliderPathBetweenView(slider: slider)
                    
                    SliderHandleView(handle: slider.lowHandle)
                        .highPriorityGesture(slider.lowHandle.sliderDragGesture)
                    
                    SliderHandleView(handle: slider.highHandle)
                        .highPriorityGesture(slider.highHandle.sliderDragGesture)
                }
            )
    }
}

struct SliderHandleView: View {
    @StateObject var handle: SliderHandle
    
    var body: some View {
        ZStack {
            Text("\(Int(handle.currentValue))")
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
                .offset(y: 25)
            
            Circle()
                .frame(width: handle.diameter, height: handle.diameter)
                .foregroundColor(.theme)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
                .scaleEffect(handle.onDrag ? 1.3 : 1)
                .contentShape(Rectangle())
        }
        .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
}

struct SliderPathBetweenView: View {
    @StateObject var slider: CustomSlider
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color.theme, lineWidth: slider.lineWidth)
    }
}
