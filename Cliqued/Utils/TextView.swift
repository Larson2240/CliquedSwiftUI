//
//  d.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 23.06.2023.
//

import SwiftUI

struct TextView: View {
    private var placeholder: String
    
    @Binding private var text: String
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }
    
    @State private var showingPlaceholder = false
    
    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }
    
    var body: some View {
        UITextViewWrapper(text: internalText)
            .background(placeholderView, alignment: .topLeading)
    }
    
    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder)
                    .font(.themeBook(14))
                    .foregroundColor(.colorMediumGrey)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        textView.isEditable = true
        textView.font = CustomFont.THEME_FONT_Book(14)
        textView.isSelectable = true
        textView.showsVerticalScrollIndicator = false
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.textColor = Constants.color_DarkGrey
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
    }
}
