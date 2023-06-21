//
//  PageIndicator.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 21.06.2023.
//

import SwiftUI

struct PageIndicator: View {
    private let spacing: CGFloat = 10
    private let diameter: CGFloat = 8
    
    let numPages: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            ForEach(0..<numPages, id: \.self) {
                Indicator(pageIndex: $0, selectedPage: $selectedIndex)
                    .frame(width: diameter, height: diameter)
            }
        }
        .animation(.spring())
    }
}

private struct Indicator: View {
    let pageIndex: Int
    
    @Binding var selectedPage: Int
    
    var body: some View {
        Circle()
            .foregroundColor(selectedPage == pageIndex ? .white : .gray)
    }
}

struct PageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PageIndicator(numPages: 4, selectedIndex: .constant(2))
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
