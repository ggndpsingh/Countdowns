//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit

extension CKContainer {
    func getUserRecordID() -> CKRecord.ID? {
        var recordID: CKRecord.ID?
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .userInitiated).async {
            CKContainer.default().fetchUserRecordID { id, error in
                DispatchQueue.main.async {
                    recordID = id
                }
            }
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return recordID
    }

    func isUserDiscoverabilityPermissionGranted(completion: @escaping ((Bool) -> Void)) {
        status(forApplicationPermission: .userDiscoverability) { status, error in
            DispatchQueue.main.async {
                completion(status == .granted)
            }
        }
    }

    func getUserIdentity(withUserID id: CKRecord.ID, completion: @escaping ((CKUserIdentity?) -> Void)) {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
            CKContainer.default().discoverUserIdentity(withUserRecordID: id) { identity, _ in
                DispatchQueue.main.async {
                    completion(identity)
                }
            }
        }
    }
}
