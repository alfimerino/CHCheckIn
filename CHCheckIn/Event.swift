//
//  Event.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/30/24.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String = ""
    var location: String = ""
    var people: [Person]? = [Person]()

    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
