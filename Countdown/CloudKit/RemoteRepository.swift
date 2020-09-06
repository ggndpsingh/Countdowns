//
//  RemoteRepository.swift
//  Countdown
//
//  Created by Gagandeep Singh on 5/9/20.
//

import Foundation
import CloudKit

class RemoteRepository<T: CloudKitRecord> {
    let predicate: NSPredicate
    var sortDescriptors: [NSSortDescriptor]
    var fetchLimit: Int
    var cursor: CKQueryOperation.Cursor?

    var recordFetchedBlock: ((T) -> Void)?
    var queryCompletedBlock: ((Error?) -> Void)?

    init(predicate: NSPredicate = NSPredicate(value: true), sort: [NSSortDescriptor] = [], limit: Int = CKQueryOperation.maximumResults) {
        self.predicate = predicate
        self.sortDescriptors = sort
        self.fetchLimit = limit
    }

    var canLoadMore: Bool {
        return cursor != nil
    }

    func fetch(recordFetchedBlock: @escaping ((T) -> Void), queryCompletedBlock: ((Error?) -> Void)? = nil) {

        self.recordFetchedBlock = recordFetchedBlock
        self.queryCompletedBlock = queryCompletedBlock

        let query = CKQuery(recordType: T.recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors

        let operation: CKQueryOperation = .init(query: query)
        operation.cursor = cursor
        operation.resultsLimit = fetchLimit

        operation.recordFetchedBlock = recordFetched(_:)
        operation.queryCompletionBlock = fetchCompleted(_:_:)

        DispatchQueue.global(qos: .userInitiated).async {
            T.database.add(operation)
        }
    }

    func recordFetched(_ record: CKRecord?) {
        DispatchQueue.main.async {
            guard let record = record else { return }
            self.recordFetchedBlock?(.init(from: record))
        }
    }

    func fetchCompleted(_ cursor: CKQueryOperation.Cursor?, _ error: Error?) {
        if let error = error {
            print("Failed to load records in \(self). Error: \(error)")
        }

        DispatchQueue.main.async {
            self.cursor = cursor
            self.queryCompletedBlock?(error)
        }
    }
}
