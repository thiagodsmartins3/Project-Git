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
    
    lazy private var informationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy private var informationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var userLoginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Just Testing"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var userLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "São Francisco"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
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
        
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        userImageView.addSubview(userLoginNameLabel)
        userImageView.addSubview(userLocationLabel)
        
        informationView.addSubview(userImageView)
        
        informationScrollView.addSubview(informationView)
        
        view.addSubview(informationScrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
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
        ])
    }
}
