//
//  VerificationViewModel.swift
//  CHCheckIn
//
//  Created by Alfredo Merino on 1/31/24.
//

import CloudKit
import Foundation

class VerificationViewModel: ObservableObject {
    let privateDatabase = CKContainer.default().publicCloudDatabase

    func validateCode(for userId: String, inputCode: Int, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "userId == %@", userId)
        let query = CKQuery(recordType: "VerificationCode", predicate: predicate)

        privateDatabase.perform(query, inZoneWith: nil) { records, error in

            if let error = error {
                print(error.localizedDescription)
                completion(false)
                // Handle error
            } else if let record = records?.first, let code = record["code1"] as? Int {
                // You can also check the expiration date here if you have that field
                completion(code == inputCode)
            } else {
                completion(false)
                // Handle case where record is not found or code doesn't match
                print("wrong wrong")
            }
        }
    }

}
