//
//  NetworkManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation

enum NetworkError: Error {
    case networkError
}

class NetworkManager {
    static let shared = NetworkManager(session: URLSession.shared)
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }

    @discardableResult
    func get<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error !! \(error)")
                DispatchQueue.main.sync {
                    completion(.failure(error))
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            if let data = data, let items = try? jsonDecoder.decode(type, from: data) {
                DispatchQueue.main.sync {
                    completion(.success(items))
                }
            } else {
                DispatchQueue.main.sync {
                    completion(.failure(NetworkError.networkError))
                }
            }
        }
        task.resume()
        return task
    }
}
