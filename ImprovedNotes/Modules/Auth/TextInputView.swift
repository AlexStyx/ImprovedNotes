//
//  TextInputView.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/13/22.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(height: 45)
            .textFieldStyle(PlainTextFieldStyle())
            .padding([.horizontal], 15)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white))
            .padding([.horizontal], 24)
            .foregroundColor(.white)
            .onChange(of: text) { newValue in
            }
        
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(text: .constant("Test"), placeholder: "Email")
    }
}
