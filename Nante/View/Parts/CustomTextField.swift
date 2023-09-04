//
//  UITextField.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/02.
//


import SwiftUI


struct CustomTextField: UIViewRepresentable {
    var placeholder: String = "" 
    @Binding var text: String

    func makeUIView(context: Context) -> CustomUITextField {
        let textField = CustomUITextField()
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: CustomUITextField, context: Context) {
        uiView.text = text
        // uiView.textField.placeholder = placeholder: TODO: placeholderが動くように修正
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
