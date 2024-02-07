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
            }
                .navigationTitle("Visit Log")
        }
    }
}

struct VisitRowView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Visitor: Paul Hudson")
                Spacer()
            }
            HStack {
                Text("Person Visiting: Roger M.")
                Spacer()
            }
            HStack {
                Text("Date Registered: 12/12/2023")
                Text("at: 13:21")
                Spacer()
            }
        }
    }
}

#Preview {
    VisitLogView()
}
