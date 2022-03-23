//
//  LoginButton.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/13/22.
//

import SwiftUI

struct LoginButton: View {
    @Binding var state: AuthViewState
    var didTap: () -> ()
    var body: some View {
        Button(state == .login ? "Log In" : "Sign Up") {
           didTap()
        }
        .frame(width:130, height:45)
        .background(Color.blue)
        .cornerRadius(30)
        .foregroundColor(.white)

    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(state: .constant(.login)) {}
    }
}
