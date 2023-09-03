//
//  InformationWorker.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

class InformationWorker {
    private let serviceAPI = ServiceAPI()
    
    func requestUserInformation(_ endpoint: String) async throws -> UserInformationModel {
        return try await serviceAPI.fetchData(.endpoint(url: endpoint), dataType: UserInformationModel.self)
    }
    
    func requestQuotes(_ endpoint: String) async throws -> QuotesModel {
        return try await serviceAPI.fetchData(.endpoint(url: endpoint, isOtherUrl: true), dataType: QuotesModel.self)
    }
}
