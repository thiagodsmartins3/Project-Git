//
//  ServiceAPI.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 02/09/23.
//

import Foundation
import Alamofire

enum ServiceURL {
    case endpoint(url: String)
}

extension ServiceURL {
    var path: String {
        switch self {
        case .endpoint(let url):
            return "https://api.github.com/\(url)"
        }
    }
}

final class ServiceAPI {
    func fetchData<T: Codable>(_ endpoint: ServiceURL, dataType: T.Type) async throws -> T {
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
