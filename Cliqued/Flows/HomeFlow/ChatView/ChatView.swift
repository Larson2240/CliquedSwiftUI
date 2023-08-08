//
//  ChatView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 02.08.2023.
//

import SwiftUI

struct ChatView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ChatVC.loadFromNib()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
