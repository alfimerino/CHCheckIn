//
//  PeopleView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/29/24.
//

import SwiftData
import SwiftUI

struct PeopleView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    @State private var showEditView = false
    @Query var people: [Person]
    var body: some View {
        List {
            ForEach(people) { person in
                    NavigationLink(value: person) {
                        Text(person.name)
                    }
            }
            .onDelete(perform: deletePeople)
        }
    }

    init(navigationPath: Binding<NavigationPath> , searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        _navigationPath = navigationPath
        _people = Query(filter: #Predicate { person in
            if searchString.isEmpty {
                true
            } else {
                person.name.localizedStandardContains(searchString)
                || person.emailAddress.localizedStandardContains(searchString)
                || person.details.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }

    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return PeopleView(navigationPath: .constant(NavigationPath())).modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
