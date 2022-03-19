//
//  AuthView.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/13/22.
//

import SwiftUI
import UIKit

struct AuthView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var loginButtonTitle: String = "Sign Up"
    @State private var showLogin = true
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                
                Text("Better Notes")
                    .foregroundColor(.white)
                    .font(.custom("Marker Felt", size: 40))
                
                if !viewModel.loginSuccss{
                    Text("Invalid email or password")
                        .foregroundColor(.red)
                }
               
                
                TextInputView(text: $login, placeholder: "Login")
                
                TextInputView(text: $password, placeholder: "Password")
                
                LoginButton(showLogin: $showLogin) {
                    showLogin ? viewModel.signInTapped(email: login, password: password) : viewModel.registerButtonTapped(email: login, password: password)
                }
                
                Spacer()

                ChangeStateButton(showLogin: $showLogin)
                    .padding()
                
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: AuthViewModel())
    }
}
