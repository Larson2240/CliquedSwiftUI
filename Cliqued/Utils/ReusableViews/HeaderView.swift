//
//  HeaderView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var title: String
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("ic_back_black")
                }
                
                Spacer()
            }
            
            
            Text(title)
                .font(.themeBold(16))
                .foregroundColor(.colorSenderTextMsg)
        }
        .padding(.horizontal, 20)
        .frame(height: 25)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title")
    }
}
