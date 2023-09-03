//
//  InformationPresenter.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

protocol InformationPresentationLogic {
    func presentUserInformation(response: Information.User.Response)
    func presentQuote(response: Information.Quote.Response)
    func presentLoading(response: Information.Loading.Response)
    func presentError(response: Information.ErrorMessage.Response)
}

class InformationPresenter: InformationPresentationLogic {
    weak var viewController: InformationDisplayLogic?
    
    func presentUserInformation(response: Information.User.Response) {
        viewController?.displayUserInformation(viewModel: .init(userData: response.response))
    }
    
    func presentLoading(response: Information.Loading.Response) {
        viewController?.displayLoading(viewModel: .init(isLoading: response.isLoading))
    }
    
    func presentError(response: Information.ErrorMessage.Response) {
        viewController?.displayErrorMessage(viewModel: .init(message: response.message))
    }
    
    func presentQuote(response: Information.Quote.Response) {
        viewController?.displayQuote(viewModel: .init(quoteData: response.response))
    }
}
