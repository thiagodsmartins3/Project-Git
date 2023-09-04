//
//  HomeViewController.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit.UIViewController
import Alamofire
import Combine

// MARK: HOME DISPLAY LOGIC PROTOCOL
protocol HomeDisplayLogic: AnyObject {
    func displayUsers(viewModel: Home.Users.ViewModel)
    func displayRefreshUsers(viewModel: Home.Users.ViewModel)
    func displayLoading(viewModel: Home.Loading.ViewModel)
    func displayErrorMessage(viewModel: Home.ErrorMessage.ViewModel)
    func displayRefreshErrorMessage(viewModel: Home.ErrorMessage.ViewModel)
}

// MARK: HOME VIEW CONTROLLER
class HomeViewController: UIViewController,
                          HomeDisplayLogic {
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    lazy var loaderActivityView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.backgroundColor = .white
        loader.color = Asset.royal.color
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = L10n.Searchbar.Text.placeholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    lazy var informationTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            UsersTableViewCell.self,
            forCellReuseIdentifier: UsersTableViewCell.identifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var emptyMessageView: UIView = {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Error.Empty.message
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Asset.grey.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView(
            image: Asset.Images.githubImage.image
        )
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var pushToRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(
            string: L10n.Refresh.Text.message,
            attributes: [
            NSAttributedString.Key.foregroundColor : Asset.royal.color
        ])
        refresh.tintColor = Asset.royal.color
        refresh.addTarget(
            self,
            action: #selector(didPushToRefresh(_:)),
            for: UIControl.Event.valueChanged
        )
        
        return refresh
    }()
    
    private var usersData: UsersModel? = nil {
        didSet {
            DispatchQueue.main.async {
                self.informationTableView.reloadData()
            }
        }
    }
    
    private var isSearchActive = false
    private var filteredSearch: UsersModel?
    private var userNotFoundText = ""
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        
        Task {
            try await interactor?.requestUsers(request: .init(endpoint: "users"))
        }
    }
    
    private func userNotFoundMessage() {
        emptyMessageLabel.text = L10n.Error.Notfound.message(userNotFoundText)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = Asset.royal.color
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left.circle.fill")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "square.and.arrow.up.on.square.fill")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


// MARK: TABLE VIEW IMPLEMENTATIONS
extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let data = usersData else {
            return 0
        }
        
        if isSearchActive {
            guard let searchData = filteredSearch else {
                return 0
            }
            
            if searchData.count == 0 {
                self.emptyMessageView.isHidden = false
                userNotFoundMessage()
                return 0
            } else {
                self.emptyMessageView.isHidden = true
                return searchData.count
            }
        } else {
            self.emptyMessageView.isHidden = true
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UsersTableViewCell.identifier,
            for: indexPath) as! UsersTableViewCell

        if isSearchActive {
            AF.download(filteredSearch![indexPath.row].avatarURL)
                .downloadProgress {
                    progress in
                    
                }
                .responseData { response in
                    if let data = response.value {
                        cell.avatarImageView.image = UIImage(data: data)
                    }
                }
            
            cell.loginLabel.text = filteredSearch![indexPath.row].login
            cell.link = filteredSearch![indexPath.row].htmlURL
            cell.linkData = cell.linkSelected.sink { response in
                print(response)
            } receiveValue: { data in
                self.router?.navigateToUrl(data)
            }
        } else {
            AF.download(usersData![indexPath.row].avatarURL, requestModifier: {
                urlRequest in
                
                urlRequest.timeoutInterval = 15
            })
            .downloadProgress {
                progress in
                    
            }
            .responseData { response in
                if let data = response.value {
                    cell.avatarImageView.image = UIImage(data: data)
                } else {
                    cell.avatarImageView.image = Asset.Images.githubImage.image
                }
            }
            
            cell.loginLabel.text = usersData![indexPath.row].login
            cell.link = usersData![indexPath.row].htmlURL
            cell.linkData = cell.linkSelected.sink { response in
                print(response)
            } receiveValue: { data in
                self.router?.navigateToUrl(data)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            router?.navigateToInformation(filteredSearch![indexPath.row].login)
        } else {
            router?.navigateToInformation(usersData![indexPath.row].login)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 12

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x,
                                 y: cell.bounds.origin.y,
                                 width: cell.bounds.width,
                                 height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}


// MARK: HOME DISPLAY LOGIC IMPLEMENTATIONS
extension HomeViewController {
    func displayUsers(viewModel: Home.Users.ViewModel) {
        usersData = viewModel.usersData
    }
    
    func displayLoading(viewModel: Home.Loading.ViewModel) {
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
    
    func displayErrorMessage(viewModel: Home.ErrorMessage.ViewModel) {
        DispatchQueue.main.async {
            self.informationTableView.reloadData()
            self.emptyMessageView.isHidden = false
        }
        
        router?.displayError(L10n.Error.Request.message)
    }
    
    func displayRefreshUsers(viewModel: Home.Users.ViewModel) {
        DispatchQueue.main.async {
            self.pushToRefresh.endRefreshing()
        }
        
        usersData = viewModel.usersData
    }
    
    func displayRefreshErrorMessage(viewModel: Home.ErrorMessage.ViewModel) {
        DispatchQueue.main.async {
            self.pushToRefresh.endRefreshing()
        }
        
        router?.displayRefreshError(L10n.Refresh.Error.message)
    }
}


// MARK: UISEARCH IMPLEMENTATIONS
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let data = usersData else {
            return
        }
        
        if searchText.isEmpty {
            isSearchActive = false
            informationTableView.reloadData()
        } else {
            filteredSearch = data.filter {
                $0.login.lowercased().contains(searchText.lowercased())
            }
            
            isSearchActive = true
            userNotFoundText = searchText
            informationTableView.reloadData()
        }
    }
}


// MARK: PULL TO REFRESH EVENT
extension HomeViewController {
    @objc private func didPushToRefresh(_ sender: UIRefreshControl) {
        Task {
            try await interactor?.requesRefreshUsers(request: .init(endpoint: "users"))
        }
    }
}
