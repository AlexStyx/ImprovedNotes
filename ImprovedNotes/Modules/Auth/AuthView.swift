//
//  AuthView.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/13/22.
//

import SwiftUI
import UIKit

struct AuthView: View {
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isVerifiedEmail: Bool = false
    @State private var loginButtonTitle: String = "Sign Up"
    @State private var isEnabled = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Simple Notes")
                    .foregroundColor(.white)
                    .font(.custom("Marker Felt", size: 40))
                
                TextInputView(text: $login, placeholder: "Login")
                
                TextInputView(text: $password, placeholder: "Password")
                
                LoginButton(title: $loginButtonTitle, isEnabled: $isEnabled) {
                    
                }
                
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
