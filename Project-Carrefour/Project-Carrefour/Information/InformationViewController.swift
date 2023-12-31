//
//  InformationViewController.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit
import Alamofire

// MARK: INFORMATION DISPLAY LOGIC PROTOCOL
protocol InformationDisplayLogic: AnyObject {
    func displayUserInformation(viewModel: Information.User.ViewModel)
    func displayQuote(viewModel: Information.Quote.ViewModel)
    func displayLoading(viewModel: Information.Loading.ViewModel)
    func displayErrorMessage(viewModel: Information.ErrorMessage.ViewModel)
}


// MARK: INFORMATION VIEW CONTROLLER
class InformationViewController: UIViewController,
                                 InformationDisplayLogic {

    var interactor: InformationBusinessLogic?
    var router: (NSObjectProtocol & InformationRoutingLogic & InformationDataPassing)?
    
    lazy var loaderActivityView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.backgroundColor = .white
        loader.color = Asset.royal.color
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var imageProgressView: UIProgressView = {
        let loader = UIProgressView(progressViewStyle: .bar)
        loader.backgroundColor = .white
        loader.progress = 0.0
        loader.progressTintColor = Asset.royal.color
        loader.transform = loader.transform.scaledBy(x: 1, y: 8)
        loader.layer.cornerRadius = 8
        loader.clipsToBounds = true
        loader.layer.sublayers![1].cornerRadius = 8
        loader.subviews[1].clipsToBounds = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var informationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var informationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = Asset.royal.color.cgColor
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userLoginNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    lazy var userInformationView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    lazy var userGreetingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var userMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = L10n.Information.Text.message
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userBioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            Asset.turquoise.color.cgColor,
            Asset.royal.color.cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(didSwipeBack(_:)))
        swipeGesture.direction = .right
        return swipeGesture
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
        
        let backButton = UIBarButtonItem()
        backButton.title = L10n.Navigation.Back.message
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        setupViews()
        
        Task {
            do {
                try await self.interactor?.requestUserInformation(request: .init(endpoint: "users/\(endpoint!)"))
            } catch let error {
                print(error.localizedDescription)
            }
            
            do {
                try await self.interactor?.requestQuotes(request: .init(endpoint: "https://zenquotes.io/api/random"))
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
            
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = userInformationView.bounds
    }
}


// MARK: INFORMATION DISPLAY LOGIC IMPLEMENTATIONS
extension InformationViewController {
    func displayUserInformation(viewModel: Information.User.ViewModel) {
        if let imageUrl = viewModel.userData.avatarURL {
            AF.download(imageUrl)
                .downloadProgress {
                    progress in
                    
                    self.imageProgressView.progress = Float(progress.fractionCompleted)
                    
                    if progress.isFinished {
                        self.imageProgressView.isHidden = true
                        self.userImageView.alpha = 0
                    }
                }
                .responseData { response in
                    if response.error != nil {
                        self.userImageView.image = UIImage(systemName: "person.crop.square.fill")
                        UIImageView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseIn, animations: {
                             self.userImageView.alpha = 1.0
                        })
                    } else {
                        if let data = response.value {
                            self.userImageView.image = UIImage(data: data)
                            self.userImageView.layer.borderWidth = 3
                            
                            UIImageView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseIn, animations: {
                                 self.userImageView.alpha = 1.0
                            })
                        }
                    }
                }
        }
        
        DispatchQueue.main.async {
            self.userLoginNameLabel.text = viewModel.userData.login
            self.userLocationLabel.text = viewModel.userData.location
            self.userGreetingsLabel.text = L10n.Information.Text.user + (viewModel.userData.name ?? "")
        }
    }
    
    func displayQuote(viewModel: Information.Quote.ViewModel) {
        DispatchQueue.main.async {
            self.userBioLabel.text = viewModel.quoteData[0].q
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
        router?.displayError(viewModel.message)
    }
}


// MARK: SWIPE TO BACK EVENT
extension InformationViewController {
    @objc private func didSwipeBack(_ sender: UISwipeGestureRecognizer) {
        router?.navigateBack()
    }
}
