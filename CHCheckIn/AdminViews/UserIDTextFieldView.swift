//
//  UserIDTextFieldView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/7/24.
//

import SwiftUI

struct UserIDTextFieldView: View {
    @Binding var userId: String

    var body: some View {
        TextField("UserID", text: $userId)
            .padding(.horizontal, 5)
            .frame(height: 40)
            .frame(maxWidth: 300)
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

#Preview {
    UserIDTextFieldView(userId: .constant("User"))
}
