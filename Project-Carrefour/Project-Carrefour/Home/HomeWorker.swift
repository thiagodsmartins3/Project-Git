//
//  HomeWorker.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit
import Alamofire
import Combine

enum ServiceWorker {
    case endpoint(url: String)
}

extension ServiceWorker {
    var path: String {
        switch self {
        case .endpoint(let url):
            return "https://api.github.com/\(url)"
        }
    }
}

final class HomeWorker {
    func fetchData<T: Codable>(_ endpoint: ServiceWorker, dataType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation {
            continuation in
            
            AF.request(
                endpoint.path,
                method: .get,
                parameters: .none
            )
            .responseDecodable(of: T.self) {
                response in
                
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
