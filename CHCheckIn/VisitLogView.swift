//
//  VisitLogView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/6/24.
//

import SwiftUI

struct VisitLogView: View {
    @StateObject var viewModel = VisitLogViewModel()
    var body: some View {
        VStack {
            List(viewModel.visitLogs) { log in
                VisitRowView(log: log)
            }
            .listStyle(.inset)
                .navigationTitle("Visit Log")
        }
        .onAppear {
            viewModel.fetchVisitLogs()
            print(viewModel.visitLogs)
            }
    }
}

struct VisitRowView: View {
    @State private var visitReasonText = "Day out at the park, and Tommy's birthday."
    var log: VisitLog
    var body: some View {
        VStack {
            HStack {
                Text("Visitor: \(log.visitorName)")
                Spacer()
                Text("\(log.visitStartDate.formatted(date: .abbreviated, time: .shortened))")
            }
            HStack {
                Text("Person Visiting: \(log.personVisitingName)")
                Spacer()
            }
            HStack(alignment: .top) {
                Text("Visit Reason:")
                TextField("", text: Binding(
                    get: { self.log.reasonForVisit},
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
