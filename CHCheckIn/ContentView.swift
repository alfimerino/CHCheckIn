//
//  ContentView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/29/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Person.name)]
    @State private var searchText = ""
    @State private var adminOn = false
    @State private var presentCheckIn = false
    @State private var presentVerificationView = false

    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("Visitor View")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person, navigationPath: $path, admin: false)
                        .environment(\.viewOrigin, .view1)
                }
                .navigationDestination(isPresented: $presentCheckIn,destination: {
                    CheckInView(navigationPath: $path)
                })
                .navigationDestination(isPresented: $presentVerificationView, destination: {
                    VerificationView()
                })

                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.name)])

                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }
                    Button("Add Person", systemImage: "plus", action: addPerson)
                    Button("Visitor Check-In", systemImage: "person") {
                        presentCheckIn.toggle()
                    }

                    Button("Visitor Check-In", systemImage: "gearshape.fill") {
                        presentVerificationView.toggle()
                    }
                }
                .searchable(text: $searchText)
        }
    }

    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ContentView().modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview \(error.localizedDescription)")
    }
}
