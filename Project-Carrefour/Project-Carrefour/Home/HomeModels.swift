//
//  HomeModels.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit
import Combine

enum Home {
    // MARK: Use cases
    
    enum Users {
        struct Request {
            let endpoint: String
        }
        struct Response {
            let response: UsersModel
        }
        struct ViewModel {
            let usersData: UsersModel
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
