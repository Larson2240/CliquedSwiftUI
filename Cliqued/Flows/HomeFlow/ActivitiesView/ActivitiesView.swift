//
//  ActivitiesView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 02.08.2023.
//

import SwiftUI

struct ActivitiesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ActivitiesVC.loadFromNib()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
