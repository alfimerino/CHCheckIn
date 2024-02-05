//
//  VerificationView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/31/24.
//

import SwiftUI

struct VerificationView: View {
    @StateObject var viewModel = VerificationViewModel()
    @State private var inputCode: String = ""
    @State private var userId: String = ""
    @State private var loginSuccess: Bool?

    var body: some View {
        VStack(spacing: 20) {
            TextField(" UserID", text: $userId)
                .keyboardType(.alphabet)
                .frame(height: 40)
                .border(Color.gray, width: 2)
                .frame(maxWidth: 300)
            SecureField(" Code", text: $inputCode)
                .keyboardType(.numberPad)
                .frame(height: 40)
                .border(Color.gray, width: 2)
                .frame(maxWidth: 300)

            Button("Log in") {
                viewModel.validateCode(for: userId.lowercased(), inputCode: Int(inputCode) ?? 0) { isValid in
                    if isValid {
                        print("Code is valid")
                        // Perform action on successful validation
                        loginSuccess = true
                    } else {
                        print("Invalid code")
                        // Handle invalid code
                        loginSuccess = false
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            VStack {
                if let loginSuccess, loginSuccess == true {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                } else if let loginSuccess, loginSuccess == false {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
            }

        }.navigationTitle("Admin")
    }
}

#Preview {
    VerificationView()
}
