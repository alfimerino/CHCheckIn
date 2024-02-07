//
//  CodeTextFieldView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/7/24.
//

import SwiftUI

struct CodeTextFieldView: View {
    @Binding var inputCode: String
    var body: some View {
        SecureField("Code", text: $inputCode)
            .padding(.horizontal, 5)
            .frame(height: 40)
            .frame(maxWidth: 300)
            .keyboardType(.numberPad)
            .autocorrectionDisabled()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

#Preview {
    CodeTextFieldView(inputCode: .constant("4455"))
}
