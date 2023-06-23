//
//  View + Extension.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 23.05.2023.
//

import SwiftUI

extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func limitText(for binding: Binding<String>, to upper: Int) {
        if binding.wrappedValue.count > upper {
            binding.wrappedValue = String(binding.wrappedValue.prefix(upper))
        }
    }
    
    func endEditing() {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap({ $0 })
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.endEditing(true)
    }
    
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    var scale: CGFloat {
        let idealSize = CGSize(width: 375, height: 812)
        return min(1, screenSize.hypot / idealSize.hypot, 1)
    }
    
    func scaled(_ constant: CGFloat) -> CGFloat {
        return constant * scale
    }
    
    var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    func toggleTabBar(isHidden: Bool) {
        NotificationCenter.default.post(name: isHidden ? .hideTabBar : .showTabBar, object: nil)
    }
}
