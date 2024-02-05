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
//    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath

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

    @Query(sort: [
        SortDescriptor(\Person.name)
    ]) var people: [Person]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Visitor Information"), footer: Text("Don't see your name on the list? Tap Add Visitor to create an account.")) {
                    if people.isEmpty == false {
                        Picker("Select Visitor", selection: $selectedPerson) {
                            ForEach(people) { person in
                                Text(person.name).tag(Optional(person))
                            }
                        }.onAppear {
                            reviewAllFields()
                        }
                    }
                    Button("Add new Visitor", systemImage: "plus", action: addPerson)
                        .navigationDestination(for: Person.self) { person in
                            EditPersonView(person: person, navigationPath: $navigationPath, admin: true)
                                .environment(\.viewOrigin, .view2)
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
                    Text("By submitting this form, you acknowledge and agree to comply with our Terms and Conditions and Privacy Policy.")
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            showAgreementSheet = true
                        }.sheet(isPresented: $showAgreementSheet) {
                            Text("""
Agreement to Terms and Conditions

By submitting this form, I hereby acknowledge and agree to the following terms and conditions:

Accuracy of Information: All the information I have provided in this form is accurate, complete, and truthful to the best of my knowledge.
Updates and Changes: I understand that it is my responsibility to update any information provided in this form should it change in the future.
Data Use and Privacy: I consent to the collection, use, and disclosure of the personal information provided in this form as outlined in the Privacy Policy (link to your privacy policy).
Policy and Regulation Compliance: I agree to comply with all relevant policies and regulations that are associated with the submission of this form and the related services or products.
Confirmation of Agreement: I acknowledge that submitting this form constitutes a legal agreement and that I am bound by the terms and conditions herein.
""")
                        }
                }

                HStack(spacing: 20) {
                    Spacer()
                    Button("Submit") {

                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!enableSubmit)
                    Button("Cancel") {

                    }.buttonStyle(.bordered)
                    Spacer()
                }
            }
        }
        .navigationTitle("Visitor Check-In")
    }

    func addPerson() {
        let person = Person(name: "", emailAddress: "", details: "")
        modelContext.insert(person)
        navigationPath.append(person)
    }

    func reviewAllFields() {
        if people.isEmpty {
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
}

#Preview {
    do {
        let previewer = try Previewer()
        return CheckInView(navigationPath: .constant(NavigationPath())).modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
