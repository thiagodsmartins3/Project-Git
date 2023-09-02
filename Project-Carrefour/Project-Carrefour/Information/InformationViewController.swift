//
//  InformationViewController.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit
import Alamofire

protocol InformationDisplayLogic: AnyObject {
    func displayUserInformation(viewModel: Information.User.ViewModel)
    func displayLoading(viewModel: Information.Loading.ViewModel)
    func displayErrorMessage(viewModel: Information.ErrorMessage.ViewModel)
}

class InformationViewController: UIViewController,
                                 InformationDisplayLogic {
    
    var interactor: InformationBusinessLogic?
    var router: (NSObjectProtocol & InformationRoutingLogic & InformationDataPassing)?
    
    lazy var loaderActivityView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var imageProgressView: UIProgressView = {
        let loader = UIProgressView(progressViewStyle: .bar)
        loader.backgroundColor = .white
        loader.progress = 0.0
        loader.progressTintColor = Asset.royal.color
        loader.transform = loader.transform.scaledBy(x: 1, y: 8)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
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
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Asset.royal.color.cgColor
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var userLoginNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var userLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    private var endpoint: String!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init(_ endpoint: String) {
        self.init()
        
        self.endpoint = endpoint
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
        
        Task {
            do {
                try await self.interactor?.requestUserInformation(request: .init(endpoint: "users/\(endpoint!)"))
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupViews() {
        userImageView.addSubview(userLoginNameLabel)
        userImageView.addSubview(userLocationLabel)
        userImageView.addSubview(imageProgressView)
        
        informationView.addSubview(userImageView)
        
        informationScrollView.addSubview(informationView)
        
        view.addSubview(informationScrollView)
        view.addSubview(loaderActivityView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
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
    }
    
    func displayUserInformation(viewModel: Information.User.ViewModel) {
        AF.download(viewModel.userData.avatarURL)
            .downloadProgress {
                progress in
                
                self.imageProgressView.progress = Float(progress.fractionCompleted)
                
                if progress.isFinished {
                    self.imageProgressView.isHidden = true
                }
            }
            .responseData { response in
                if let data = response.value {
                    self.userImageView.image = UIImage(data: data)
                }
            }
        
        DispatchQueue.main.async {
            self.userLoginNameLabel.text = viewModel.userData.login
            self.userLocationLabel.text = viewModel.userData.location
        }
    }
    
    func displayLoading(viewModel: Information.Loading.ViewModel) {
        if viewModel.isLoading {
            DispatchQueue.main.async {
                self.loaderActivityView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.loaderActivityView.stopAnimating()
            }
        }
    }
    
    func displayErrorMessage(viewModel: Information.ErrorMessage.ViewModel) {
        
    }
}
