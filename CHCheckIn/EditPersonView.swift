//
//  EditPersonView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/29/24.
//

import PhotosUI
import SwiftData
import SwiftUI
import PhotosUI

struct EditPersonView: View {
    @Environment(\.viewOrigin) var viewOrigin
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath
    @State private var selectedItem: PhotosPickerItem?
    var admin: Bool


    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?

    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]

    var body: some View {
        Form {
            Section {
                if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                    if admin {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("\(Image(systemName: "checkmark")) Photo ID Submitted")
                    }
                }

                Button("\(Image(systemName: "camera")) Capture ID Card") {
                    self.showCamera.toggle()
                }
                .fullScreenCover(isPresented: self.$showCamera) {
                    AccessCameraView(selectedImage: self.$selectedImage)
                }
            }
            Section {
                TextField("Name", text: $person.name)
                    .textContentType(.name)

                TextField("Email Address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)

            }

            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.metAt) {
                    Text("Unknown event")
                        .tag(Optional<Event>.none)

                    if events.isEmpty == false {
                        Divider()

                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event))

                        }
                    }
                }

                Button("Add a new event", action: addEvent)
            }

            Section("Title") {
                TextField("Details", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Personal Information")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { event in
            EditEventView(event: event)
        }
        .onChange(of: selectedImage, loadPhoto)
        .onDisappear {
            if person.name.isEmpty {
                modelContext.delete(person)
            }
        }
    }

    func addEvent() {
        let event = Event(name: "", location: "")
        modelContext.insert(event)
        navigationPath.append(event)

    }

    func loadPhoto() {
        Task { @MainActor in
            if let image = selectedImage {
                person.photo = image.jpegData(compressionQuality: 1.0)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return EditPersonView(person: previewer.person, navigationPath: .constant(NavigationPath()), admin: true).modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
