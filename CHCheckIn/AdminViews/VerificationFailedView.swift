//
//  VerificationFailedView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/7/24.
//

import SwiftUI

struct VerificationFailedView: View {
    var body: some View {
        HStack {
            Image(systemName: "x.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 23)
            Text("Username or Passcode Incorrect")
                .bold()
            Spacer()
        }
        .padding()
        .frame(height: 80)
        .frame(maxWidth: 340)
        .foregroundStyle(Color.red)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    VerificationFailedView()
}
