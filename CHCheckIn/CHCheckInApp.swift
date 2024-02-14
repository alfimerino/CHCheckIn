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


struct ViewOriginKey: EnvironmentKey {
    static let defaultValue: ViewOrigin = .default
}

extension EnvironmentValues {
    var viewOrigin: ViewOrigin {
        get { self[ViewOriginKey.self] }
        set { self[ViewOriginKey.self] = newValue }
    }
}

enum ViewOrigin {
    case view1
    case view2
    case `default`
}
