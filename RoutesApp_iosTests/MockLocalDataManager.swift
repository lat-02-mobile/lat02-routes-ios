//
//  MockLocalDataManager.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 10/13/22.
//

import CoreData
@testable import RoutesApp_ios

class MockLocalDataManager: LocalDataManagerProtocol {
    var dataHasBeenRetrieved = false
    var sendWithError = false
    func retrieveAllDataFromFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
        } else {
            dataHasBeenRetrieved = true
            completion(.success(()))
        }
    }

    func getDataFromCoreData<T>(type: T.Type, forEntity: String, completion: @escaping (Result<[T], Error>) -> Void) where T : NSManagedObject {
        completion(.success(Array<T>()))
    }
}
