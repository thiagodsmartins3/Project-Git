//
//  HomeInteractor.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit

protocol HomeBusinessLogic {
    func requestUsers(request: Home.Users.Request) async throws
}

protocol HomeDataStore {
    //var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    
    func requestUsers(request: Home.Users.Request) async throws {
        worker = HomeWorker()
        
        presenter?.presentLoading(response: .init(isLoading: true))
        do {
            let data = try await worker?.requestUsers(request.endpoint)
            presenter?.presentUsersData(response: .init(response: data!))
            presenter?.presentLoading(response: .init(isLoading: false))
        } catch let error {
            presenter?.presentLoading(response: .init(isLoading: false))
            presenter?.presentError(response: .init(message: error.localizedDescription))
        }
    }
}
