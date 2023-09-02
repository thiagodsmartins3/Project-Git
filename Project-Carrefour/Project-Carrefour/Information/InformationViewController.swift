//
//  InformationViewController.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

protocol InformationDisplayLogic: AnyObject {
}

class InformationViewController: UIViewController,
                                 InformationDisplayLogic {
    var interactor: InformationBusinessLogic?
    var router: (NSObjectProtocol & InformationRoutingLogic & InformationDataPassing)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = InformationInteractor()
        let presenter = InformationPresenter()
        let router = InformationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
