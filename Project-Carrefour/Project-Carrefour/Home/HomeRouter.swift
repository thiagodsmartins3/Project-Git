//
//  HomeRouter.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit
import SafariServices

@objc protocol HomeRoutingLogic: AnyObject {
    func navigateToInformation(_ endpoint: String)
    func navigateToUrl(_ url: String)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject,
                  HomeRoutingLogic,
                  HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Navigation
    func navigateToInformation(_ endpoint: String) {
        viewController?.navigationController?.pushViewController(InformationViewController(endpoint), animated: true)
    }
    
    func navigateToUrl(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            viewController?.present(vc, animated: true)
        }
    }
}
