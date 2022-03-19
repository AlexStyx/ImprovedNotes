//
//  ChangeStateButton.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 3/19/22.
//

import SwiftUI

struct ChangeStateButton: View {
    @Binding var showLogin: Bool
    var body: some View {
        HStack(spacing: 5) {
            Text(showLogin ? "First in Better Notes?" : "Already registered?")
                .foregroundColor(.gray)
            Button {
                showLogin.toggle()
            } label: {
                Text(showLogin ? "Register" : "Login")
                    .foregroundColor(.gray)
                    .underline()
            }
        }

    }
}

struct ChangeStateButton_Previews: PreviewProvider {
    static var previews: some View {
        ChangeStateButton(showLogin: .constant(true))
    }
}
