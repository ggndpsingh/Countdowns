//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit

protocol CloudKitRecord {
    associatedtype Key: RawRepresentable where Key.RawValue == String
    var id: UUID { get set }
    init(from record: CKRecord)
}

extension CloudKitRecord {
    var recordID: CKRecord.ID { .init(recordName: id.uuidString) }
     static var recordType: String { "CD_CountdownObject" }

    static var database: CKDatabase {
        return CKContainer.init(identifier: "iCloud.com.deepgagan.Countdown").privateCloudDatabase
    }

    var record: CKRecord {
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let label = child.label, let key = Key(rawValue: label) {
                record.setValue(child.value, forKey: key.rawValue)
            }
        }
        return record
    }

    func save(completion: ((Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .utility).async {
            Self.database.save(self.record) { _, error in
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }

    func update(completion: ((Error?) -> Void)? = nil) {
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.changedKeys

        operation.perRecordCompletionBlock = { record, error in
            DispatchQueue.main.async {
                completion?(error)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            Self.database.add(operation)
        }
    }

    func delete(completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            Self.database.delete(withRecordID: self.recordID) { _, error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
