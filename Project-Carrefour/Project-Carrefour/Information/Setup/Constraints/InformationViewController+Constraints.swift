//
//  InformationViewController+Constraints.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 03/09/23.
//

import Foundation
import UIKit

extension InformationViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderActivityView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderActivityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderActivityView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loaderActivityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            informationScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            informationScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            informationScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            informationView.topAnchor.constraint(equalTo: informationScrollView.topAnchor),
            informationView.leadingAnchor.constraint(equalTo: informationScrollView.leadingAnchor),
            informationView.bottomAnchor.constraint(equalTo: informationScrollView.bottomAnchor),
            informationView.trailingAnchor.constraint(equalTo: informationScrollView.trailingAnchor),
            informationView.widthAnchor.constraint(equalTo: informationScrollView.widthAnchor),
            informationView.heightAnchor.constraint(equalTo: informationScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 20),
            userImageView.centerXAnchor.constraint(equalTo: informationView.centerXAnchor),
            userImageView.widthAnchor.constraint(equalTo: informationView.widthAnchor, multiplier: 0.70),
            userImageView.heightAnchor.constraint(equalTo: informationView.heightAnchor, multiplier: 0.40),
            
            userLoginNameLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: 20),
            userLoginNameLabel.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: -20),
            userLoginNameLabel.bottomAnchor.constraint(equalTo: userLocationLabel.topAnchor, constant: -10),
            
            userLocationLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: 20),
            userLocationLabel.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: -20),
            userLocationLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -10),
                        
            imageProgressView.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            imageProgressView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            imageProgressView.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: 10),
            imageProgressView.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            userInformationView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            userInformationView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 20),
            userInformationView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -20),
            userInformationView.heightAnchor.constraint(equalToConstant: 300),
            
            userGreetingsLabel.topAnchor.constraint(equalTo: userInformationView.topAnchor, constant: 10),
            userGreetingsLabel.leadingAnchor.constraint(equalTo: userInformationView.leadingAnchor, constant: 10),
            userGreetingsLabel.trailingAnchor.constraint(equalTo: userInformationView.trailingAnchor, constant: -10),
            
            userMessageLabel.topAnchor.constraint(equalTo: userGreetingsLabel.bottomAnchor, constant: 5),
            userMessageLabel.leadingAnchor.constraint(equalTo: userInformationView.leadingAnchor, constant: 20),
            userMessageLabel.trailingAnchor.constraint(equalTo: userInformationView.trailingAnchor, constant: -20),
            
            userBioLabel.topAnchor.constraint(equalTo: userMessageLabel.bottomAnchor, constant: 20),
            userBioLabel.leadingAnchor.constraint(equalTo: userInformationView.leadingAnchor, constant: 20),
            userBioLabel.trailingAnchor.constraint(equalTo: userInformationView.trailingAnchor, constant: -29),
        ])
    }
}
