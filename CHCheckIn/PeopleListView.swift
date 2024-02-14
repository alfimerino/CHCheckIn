//
//  PeopleListView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/14/24.
//

import SwiftData
import SwiftUI

struct PeopleListView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var searchText = ""
    @State private var adminOn = false
    @State private var presentCheckIn = false
    @State private var presentVerificationView = false
    @State private var presentEditView = false

    var body: some View {
        PeopleView(navigationPath: $path, searchString: searchText, sortOrder: sortOrder)
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.name)])

                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }
                .searchable(text: $searchText)
                .navigationTitle("Visitor List")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return PeopleListView(path: .constant((NavigationPath()))).modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview \(error.localizedDescription)")
    }
}

