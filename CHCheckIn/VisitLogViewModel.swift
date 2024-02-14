//
//  VisitLogViewModel.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 2/13/24.
//

import CloudKit
import Foundation

class VisitLogViewModel: ObservableObject {
    @Published var visitLogs: [VisitLog] = []

    let publicDatabase = CKContainer.default().publicCloudDatabase

    func fetchVisitLogs() {
//        let predicate = NSPredicate(format: "visitorName == %@", "visitorName")
        let query = CKQuery(recordType: "VisitLog", predicate: NSPredicate(value: true))

        publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle any errors
                    print("An error occurred: \(error.localizedDescription)")
                } else if let records = records {
                    self?.visitLogs = records.map({ record in
                        VisitLog(
                            id: record.recordID.recordName,
                            personVisitingName: record["visitorName"] as? String ?? "",
                            reasonForVisit: record["reasonForVisit"] as? String ?? "",
                            visitEndDate: record["visitEndDate"] as? Date ?? Date(),
                            visitLocation: record["visitLocation"] as? String ?? "", 
                            visitStartDate: record["visitEndDate"] as? Date ?? Date(), 
                            visitType: record["visitType"] as? String ?? "",
                            visitorName: record["visitorName"] as? String ?? "")
                    })

                } else {
                    print("Hit this thing")
                }
            }
        }
    }
}
