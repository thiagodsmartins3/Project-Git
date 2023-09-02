//
//  HomePresenter.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit

protocol HomePresentationLogic {
    func presentUsersData(response: Home.Users.Response)
    func presentLoading(response: Home.Loading.Response)
    func presentError(response: Home.ErrorMessage.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
        
    func presentUsersData(response: Home.Users.Response) {
        viewController?.displayUsers(viewModel: .init(usersData: response.response))
    }
    
    func presentLoading(response: Home.Loading.Response) {
        viewController?.displayLoading(viewModel: .init(isLoading: response.isLoading))
    }
    
    func presentError(response: Home.ErrorMessage.Response) {
        viewController?.displayErrorMessage(viewModel: .init(message: response.message))
    }
}
