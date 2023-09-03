//
//  QuotesModel.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 03/09/23.
//

import Foundation

struct QuotesModelElement: Codable {
    let q: String
    
    enum CodingKeys: String, CodingKey {
        case q = "q"
    }

}

typealias QuotesModel = [QuotesModelElement]
