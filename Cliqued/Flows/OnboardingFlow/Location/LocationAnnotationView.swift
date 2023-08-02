//
//  LocationAnnotationView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 01.06.2023.
//

import SwiftUI

struct LocationAnnotationView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
            
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
        }
    }
}

struct LocationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAnnotationView(title: "Hello Dr.")
    }
}
