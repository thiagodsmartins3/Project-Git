//
//  InformationRouter.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit
import YSnackbar

@objc protocol InformationRoutingLogic {
    func displayError(_ message: String)
    func navigateBack()
}

protocol InformationDataPassing {
    var dataStore: InformationDataStore? { get }
}

class InformationRouter: NSObject, InformationRoutingLogic, InformationDataPassing {
    weak var viewController: InformationViewController?
    var dataStore: InformationDataStore?
    
    // MARK: Routing
    
    func displayError(_ message: String) {
        let snack = Snack(alignment: .bottom,
                          title: "Ops, correu um erro",
                          message: message,
                          reuseIdentifier: "yml.co",
                          icon: UIImage(named: "wifi"),
                          duration: 8.0)
        SnackbarManager.add(snack: snack)
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
