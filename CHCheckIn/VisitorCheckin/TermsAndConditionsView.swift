//
//  TermsAndConditionsView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/7/24.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @Binding var showAgreementSheet: Bool 
    var body: some View {
        Text("By submitting this form, you acknowledge and agree to comply with our Terms and Conditions and Privacy Policy.")
            .foregroundStyle(.secondary)
            .onTapGesture {
                showAgreementSheet = true
            }.sheet(isPresented: $showAgreementSheet) {
                VStack {
                    HStack {
                        Spacer()
                        Text("Agreement to Terms and Conditions")
                            .font(.title2)
                        Spacer()
                    }
                    Text("""
By submitting this form, I hereby acknowledge and agree to the following terms and conditions:

Accuracy of Information: All the information I have provided in this form is accurate, complete, and truthful to the best of my knowledge.

Updates and Changes: I understand that it is my responsibility to update any information provided in this form should it change in the future.

Data Use and Privacy: I consent to the collection, use, and disclosure of the personal information provided in this form as outlined in the Privacy Policy (link to your privacy policy).

Policy and Regulation Compliance: I agree to comply with all relevant policies and regulations that are associated with the submission of this form and the related services or products.

Confirmation of Agreement: I acknowledge that submitting this form constitutes a legal agreement and that I am bound by the terms and conditions herein.
""").padding([.horizontal, .top])
                }
                .padding(.top, 30)
            }
    }
}

#Preview {
    TermsAndConditionsView(showAgreementSheet: .constant(true))
}
