//
//  RangeSlider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 22.06.2023.
//

import SwiftUI
import Combine

struct RangeSlider: View {
    @StateObject var slider: CustomSlider
    
    var body: some View {
        RoundedRectangle(cornerRadius: slider.lineWidth)
            .fill(Color.colorLightGrey)
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
            circle
            
            Text("\(Int(handle.currentValue))")
                .offset(y: 25)
        }
        .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
    }
    
    private var circle: some View {
        Circle()
            .frame(width: handle.diameter, height: handle.diameter)
            .foregroundColor(.theme)
            .scaleEffect(handle.onDrag ? 2 : 1)
            .contentShape(Rectangle())
    }
}

struct SliderPathBetweenView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation)
            path.addLine(to: slider.highHandle.currentLocation)
        }
        .stroke(Color.theme, lineWidth: slider.lineWidth)
    }
}

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
    
    var diameter: CGFloat = 16
    var startLocation: CGPoint
    
    @Published var currentPercentage: SliderValue
    
    @Published var onDrag: Bool
    @Published var currentLocation: CGPoint
    
    init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderValueStart: Double, sliderValueEnd: Double, startPercentage: SliderValue) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = sliderValueStart
        self.sliderValueRange = sliderValueEnd - sliderValueStart
        
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
        guard dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth else { return }
        
        calcSliderBtnLocation(dragLocation)
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
        if dragLocation.y != sliderHeight / 2 {
            currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight / 2)
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
    let lineWidth: CGFloat = 4
    
    let valueStart: Double
    let valueEnd: Double
    
    @Published var highHandle: SliderHandle
    @Published var lowHandle: SliderHandle
    
    @SliderValue var highHandleStartPercentage = 1.0
    @SliderValue var lowHandleStartPercentage = 0.0
    
    var anyCancellableHigh: AnyCancellable?
    var anyCancellableLow: AnyCancellable?
    
    init(start: Double, end: Double, width: CGFloat) {
        self.width = width
        
        valueStart = start
        valueEnd = end
        
        highHandle = SliderHandle(sliderWidth: width,
                                  sliderHeight: lineWidth,
                                  sliderValueStart: valueStart,
                                  sliderValueEnd: valueEnd,
                                  startPercentage: _highHandleStartPercentage
        )
        
        lowHandle = SliderHandle(sliderWidth: width,
                                 sliderHeight: lineWidth,
                                 sliderValueStart: valueStart,
                                 sliderValueEnd: valueEnd,
                                 startPercentage: _lowHandleStartPercentage
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
