//
//  HomeWorker.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit
import Alamofire
import Combine


final class HomeWorker {
    private let serviceAPI = ServiceAPI()
    
    func requestUsers(_ endpoint: String) async throws -> UsersModel {
        return try await serviceAPI.fetchData(.endpoint(url: endpoint), dataType: UsersModel.self)
    }
}
