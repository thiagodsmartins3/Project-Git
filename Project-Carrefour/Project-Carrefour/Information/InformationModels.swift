//
//  InformationModels.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

enum Information {
    // MARK: Use cases
    
    enum User {
        struct Request {
            let endpoint: String
        }
        struct Response {
            let response: UserInformationModel
        }
        struct ViewModel {
            let userData: UserInformationModel
        }
    }
    
    enum Quote {
        struct Request {
            let endpoint: String
        }
        struct Response {
            let response: QuotesModel
        }
        struct ViewModel {
            let quoteData: QuotesModel
        }
    }
    
    enum Loading {
        struct Request {
            let isLoading: Bool
        }
        struct Response {
            let isLoading: Bool
        }
        struct ViewModel {
            let isLoading: Bool
        }
    }
    
    enum ErrorMessage {
        struct Request {
            let message: String
        }
        struct Response {
            let message: String
        }
        struct ViewModel {
            let message: String
        }
    }
}
