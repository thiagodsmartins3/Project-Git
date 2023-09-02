//
//  InformationInteractor.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit

protocol InformationBusinessLogic {
    
}

protocol InformationDataStore {
    //var name: String { get set }
}

class InformationInteractor: InformationBusinessLogic, InformationDataStore {
    var presenter: InformationPresentationLogic?
    var worker: InformationWorker?
}
