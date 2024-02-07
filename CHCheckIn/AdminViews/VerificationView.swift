//
//  VerificationView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/31/24.
//

import SwiftUI

struct VerificationView: View {
    @StateObject var viewModel = VerificationViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @State private var inputCode: String = ""
    @State private var userId: String = ""
    @State private var loginSuccess = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
            UserIDTextFieldView(userId: $userId)
                .focused($isTextFieldFocused)
                .onAppear {
                    isTextFieldFocused = true
                }
                .onTapGesture {
                    showError = false
                }
            CodeTextFieldView(inputCode: $inputCode)
                .onTapGesture {
                    showError = false
                }

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
                        showError = true
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .navigationDestination(isPresented: $loginSuccess) {
                VisitLogView()
            }
            VStack {
                if showError == true {
                    VerificationFailedView()
                }
            }
        }.navigationTitle("Admin")
            .onAppear {
                userId = ""
                inputCode = ""
            }
    }
}

#Preview {
    VerificationView()
}
