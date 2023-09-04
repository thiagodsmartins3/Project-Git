//
//  InformationViewController+Views.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 03/09/23.
//

import Foundation

extension InformationViewController {
    func setupViews() {
        userImageView.addSubview(userLoginNameLabel)
        userImageView.addSubview(userLocationLabel)
        userImageView.addSubview(imageProgressView)
    
        userInformationView.layer.addSublayer(gradient)
        userInformationView.addSubview(userGreetingsLabel)
        userInformationView.addSubview(userMessageLabel)
        userInformationView.addSubview(userBioLabel)
        
        informationView.addSubview(userImageView)
        informationView.addSubview(userInformationView)
        
        informationScrollView.addSubview(informationView)
        
        view.addSubview(informationScrollView)
        view.addSubview(loaderActivityView)
        view.bringSubviewToFront(loaderActivityView)
        
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        setupConstraints()
    }
}
