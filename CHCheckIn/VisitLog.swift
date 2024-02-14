//
//  VisitLog.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/13/24.
//

import Foundation

struct VisitLog: Identifiable {
    let id: String
    let personVisitingName: String
    let reasonForVisit: String
    let visitEndDate: Date
    let visitLocation: String
    let visitStartDate: Date
    let visitType: String
    let visitorName: String
}
