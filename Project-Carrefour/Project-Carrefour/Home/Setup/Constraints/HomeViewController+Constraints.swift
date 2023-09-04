//
//  HomeViewController+Constraints.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 03/09/23.
//

import Foundation
import UIKit.NSLayoutConstraint

extension HomeViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderActivityView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderActivityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderActivityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loaderActivityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            informationTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 30),
            informationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            informationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            informationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            emptyMessageView.topAnchor.constraint(equalTo: informationTableView.topAnchor),
            emptyMessageView.leadingAnchor.constraint(equalTo: informationTableView.leadingAnchor),
            emptyMessageView.bottomAnchor.constraint(equalTo: informationTableView.bottomAnchor),
            emptyMessageView.trailingAnchor.constraint(equalTo: informationTableView.trailingAnchor),
            emptyMessageView.widthAnchor.constraint(equalTo: informationTableView.widthAnchor),
            emptyMessageView.heightAnchor.constraint(equalTo: informationTableView.heightAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: emptyMessageView.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: emptyMessageView.topAnchor, constant: 100),
            emptyImageView.heightAnchor.constraint(equalToConstant: 120),
            emptyImageView.widthAnchor.constraint(equalToConstant: 120),
            
            emptyMessageLabel.centerXAnchor.constraint(equalTo: emptyMessageView.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 10),
            emptyMessageLabel.widthAnchor.constraint(equalToConstant: 150),
            emptyMessageLabel.bottomAnchor.constraint(lessThanOrEqualTo: emptyMessageView.bottomAnchor, constant: -200)
        ])
    }
}
