//
//  VisitLogView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/6/24.
//

import SwiftUI

struct VisitLogView: View {
    var body: some View {
        VStack {
            List {
                VisitRowView()
                VisitRowView()
                VisitRowView()
                VisitRowView()
            }
            .listStyle(.inset)
                .navigationTitle("Visit Log")
        }
    }
}

struct VisitRowView: View {
    @State private var visitReasonText = "Day out at the park, and Tommy's birthday."
    var body: some View {
        VStack {
            HStack {
                Text("Visitor: Paul Thomas")
                Spacer()
                Text("12/12/11 13:12")
            }
            HStack {
                Text("Person Visiting: Roger M.")
                Spacer()
            }
            HStack(alignment: .top) {
                Text("Visit Reason:")
                TextField("", text: Binding(
                    get: { self.visitReasonText},
                    set: { newValue in
                        if newValue.count <= 5 {
                            self.visitReasonText = newValue
                        }
                    }
                ))
                .disabled(true)
                Spacer()
            }
        }
    }
}

#Preview {
    VisitLogView()
}
