//
//  ProfileCommonCell.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 21.06.2023.
//

import SwiftUI

struct ProfileCommonCell: View {
    var imageName: String
    var title: String
    var details: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title.isEmpty ? "-" : title)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                
                Spacer()
                
                Text(details)
                    .font(.themeMedium(14))
                    .foregroundColor(.colorDarkGrey)
            }
            .padding(.horizontal)
            
            Color.black
                .opacity(0.3)
                .frame(height: 0.5)
        }
    }
}

struct ProfileCommonCell_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCommonCell(imageName: "ic_lookingfor",
                          title: Constants.label_lookingFor,
                          details: "Random")
    }
}
