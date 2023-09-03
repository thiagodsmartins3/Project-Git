//
//  ServiceAPI.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 02/09/23.
//

import Foundation
import Alamofire

enum ServiceURL {
    case endpoint(url: String, isOtherUrl: Bool = false)
}

extension ServiceURL {
    var path: String {
        switch self {
        case .endpoint(let url, let isOtherUrl):
            if isOtherUrl {
                return url
            } else {
                return "https://api.github.com/\(url)"
            }
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
                parameters: .none,
                requestModifier: {
                    urlRequest in
                    urlRequest.timeoutInterval = 15
                    urlRequest.allowsConstrainedNetworkAccess = false
                })
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
