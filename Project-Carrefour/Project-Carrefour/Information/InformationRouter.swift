//
//  InformationRouter.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

@objc protocol InformationRoutingLogic {
    
}

protocol InformationDataPassing {
    var dataStore: InformationDataStore? { get }
}

class InformationRouter: NSObject, InformationRoutingLogic, InformationDataPassing {
    weak var viewController: InformationViewController?
    var dataStore: InformationDataStore?
    
    // MARK: Routing
}
