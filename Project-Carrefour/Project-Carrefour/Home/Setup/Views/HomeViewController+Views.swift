//
//  HomeViewController+Views.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 03/09/23.
//

import Foundation

extension HomeViewController {
    func setupViews() {
        view.backgroundColor = Asset.smokeGray.color
        
        emptyMessageView.addSubview(emptyImageView)
        emptyMessageView.addSubview(emptyMessageLabel)
        
        informationTableView.addSubview(emptyMessageView)
        informationTableView.addSubview(pushToRefresh)
        
        view.addSubview(loaderActivityView)
        view.addSubview(searchBarView)
        view.addSubview(informationTableView)
        view.bringSubviewToFront(loaderActivityView)
        
        setupConstraints()
    }
}
