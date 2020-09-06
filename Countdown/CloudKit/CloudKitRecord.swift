//  Created by Gagandeep Singh on 6/9/20.

import Foundation
import CloudKit

protocol CloudKitRecord {
    associatedtype Key: RawRepresentable where Key.RawValue == String
    var id: CKRecord.ID { get set }
    init(from record: CKRecord)
}

extension CloudKitRecord {
    static var recordType: String { String(describing: self) }

    static var database: CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }

    var record: CKRecord {
        let record = CKRecord(recordType: Self.recordType, recordID: id)
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
            Self.database.delete(withRecordID: self.id) { _, error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
