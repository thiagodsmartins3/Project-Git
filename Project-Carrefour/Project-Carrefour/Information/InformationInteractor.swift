//
//  InformationInteractor.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

protocol InformationBusinessLogic {
    func requestUserInformation(request: Information.User.Request) async throws
    func requestQuotes(request: Information.Quote.Request) async throws
}

protocol InformationDataStore {
    //var name: String { get set }
}

class InformationInteractor: InformationBusinessLogic, InformationDataStore {
    var presenter: InformationPresentationLogic?
    var worker: InformationWorker?
    
    func requestUserInformation(request: Information.User.Request) async throws {
        worker = InformationWorker()
        
        presenter?.presentLoading(response: .init(isLoading: true))
        do {
            let data = try await worker?.requestUserInformation(request.endpoint)
            presenter?.presentUserInformation(response: .init(response: data!))
            presenter?.presentLoading(response: .init(isLoading: false))
        } catch let error {
            presenter?.presentLoading(response: .init(isLoading: false))
            presenter?.presentError(response: .init(message: error.localizedDescription))
        }
    }
    
    func requestQuotes(request: Information.Quote.Request) async throws {
        worker = InformationWorker()
        
        do {
            let data = try await worker?.requestQuotes(request.endpoint)
            presenter?.presentQuote(response: .init(response: data!))
        } catch let error {
            presenter?.presentError(response: .init(message: error.localizedDescription))
        }
    }
}
