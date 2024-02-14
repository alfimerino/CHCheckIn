//
//  CHCheckInApp.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/29/24.
//

import SwiftUI
import SwiftData

@main
struct CHCheckInApp: App {
    var body: some Scene {
        WindowGroup {
            CheckInView()
        }
        .modelContainer(for: Person.self)
    }
}
