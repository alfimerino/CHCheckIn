//
//  CheckInView.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/31/24.
//

import SwiftData
import SwiftUI

enum VisitType: String, CaseIterable, Identifiable {
    case inHouse = "In House Visit"
    case outBound = "Outbound Visit"
    var id: Self { self}
}

enum PersonNavigation {
    case createPerson(Person)
}

struct CheckInView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = VisitLogViewModel()

    @State private var navigationPath = NavigationPath()

    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var visitLocation: String = ""
    @State private var visitType: VisitType = .inHouse
    @State private var reasonForVisit: String = ""
    @State private var visitStartDate = Date.now
    @State private var visitEndDate = Date.now.addingTimeInterval(3000)
    @State private var newUserSelected = false
    @State private var agreeToTerms = false
    @State private var selectedPerson: Person?
    @State private var presentPersonEdit = false
    @State private var datesCorrect = true
    @State private var showAgreementSheet = false
    @State private var enableSubmit = false
    @State private var presentOkOnSubmit = false
    @State private var presentVerificationView = false
    @State private var presentUserListView = false
    @State private var personToVisit: String = ""

    @Query(sort: [
        SortDescriptor(\Person.name)
    ]) var people: [Person]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Form {
                    Section(header: Text("Visitor Information"), footer: Text("Don't see your name on the list? Tap Add Visitor to create an account.")) {
                        if people.isEmpty == false {
                            Picker("Select Visitor", selection: $selectedPerson) {
                                Text("None").tag(Optional<Person>.none)
                                ForEach(people) { person in
                                    Text(person.name).tag(Optional(person))
                                }
                            }.onAppear {
                                reviewAllFields()
                            }
                            .onChange(of: selectedPerson) { oldValue, newValue in
                                reviewAllFields()
                            }
                        }
                        Button("Add new Visitor", systemImage: "plus", action: addPerson)
                            .navigationDestination(for: Person.self) { person in
                                EditPersonView(person: person, navigationPath: $navigationPath, admin: true)
                                    .environment(\.viewOrigin, .view2)
                            }
                    }

                    Section(header: Text("Person to Visit")) {
                        TextField("First name, Last Initial", text: $personToVisit)
                            .onChange(of: personToVisit) { oldValue, newValue in
                                reviewAllFields()
                            }
                    }

                    Section("Visit Type") {
                        Picker("Select Visit Type", selection: $visitType) {
                            Text(VisitType.inHouse.rawValue).tag(VisitType.inHouse)
                            Text(VisitType.outBound.rawValue).tag(VisitType.outBound)
                        }
                        if visitType == .outBound {
                            TextField("Location", text: $visitLocation)
                                .onAppear {
                                    enableSubmit = false
                                }
                                .onDisappear {
                                    reviewAllFields()
                                }
                                .onChange(of: visitLocation) {
                                    reviewAllFields()
                                }
                        }
                    }

                    Section(header: Text("Visit Date & Duration"), footer: Text(datesCorrect ? "" : "Incorrect Dates").foregroundStyle(Color.red).bold()) {
                        DatePicker("Visit Start:", selection: $visitStartDate).onChange(of: visitStartDate) {
                            if visitEndDate <= visitStartDate {
                                datesCorrect = false
                            } else {
                                datesCorrect = true
                            }
                        }
                        DatePicker("Visit End:", selection: $visitEndDate).onChange(of: visitEndDate) { oldValue, newValue in
                            if visitEndDate <= visitStartDate {
                                datesCorrect = false
                            } else {
                                datesCorrect = true
                            }
                        }
                    }

                    Section("Reason for Visit") {
                        TextField("Provide a brief description of your visit.", text: $reasonForVisit, axis: .vertical)
                            .onChange(of: reasonForVisit) {
                                reviewAllFields()
                            }
                    }

                    Section(header: Text("Agreement"), footer: Text("Tap to view full Terms and Conditions")) {
                        TermsAndConditionsView(showAgreementSheet: $showAgreementSheet)
                    }
                    Section(header: Text(enableSubmit ? "" : "Fill out all form data.").foregroundStyle(Color.red)) {
                        HStack() {
                            Spacer()
                            Button("Submit") {
                                presentOkOnSubmit = true
                                let createdVisitLog = addVisitLog()
                                viewModel.saveVisitLog(createdVisitLog)
                            }
                            .fullScreenCover(isPresented: $presentOkOnSubmit, content: {
                                ModalView()
                            })
                            .frame(width: 600)
                            .buttonStyle(.borderedProminent)
                            .disabled(!enableSubmit)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Visitor Check-In")
            .toolbar {
                Button("User List", systemImage: "person.2") {
                    presentUserListView.toggle()
                }
                Button("Visitor Check-In", systemImage: "gearshape") {
                    presentVerificationView.toggle()
                }
            }.navigationDestination(isPresented: $presentUserListView) {
                PeopleListView(path: $navigationPath)
            }
            .navigationDestination(isPresented: $presentVerificationView) {
                VerificationView()
            }
        }
    }

    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "")
        modelContext.insert(person)
        navigationPath.append(person)
    }

    func reviewAllFields() {

        if selectedPerson == nil {
            enableSubmit = false
            return
        }

        if people.isEmpty {
            enableSubmit = false
            return
        }

        if personToVisit.isEmpty {
            enableSubmit = false
            return
        }

        if visitType == .outBound {
            if visitLocation.isEmpty {
                enableSubmit = false
                return
            }
        }

        if !datesCorrect {
            enableSubmit = false
            return
        }

        if reasonForVisit.isEmpty {
            enableSubmit = false
            return
        }

        enableSubmit = true
    }

    func addVisitLog() -> VisitLog {
        return VisitLog(
            id: NSUUID().uuidString, personVisitingName: name, reasonForVisit: reasonForVisit, visitEndDate: visitEndDate, visitLocation: visitLocation, visitStartDate: visitStartDate, visitType: visitType.rawValue, visitorName: personToVisit)
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Your Visit was Recorded Successfully")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return CheckInView().modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
