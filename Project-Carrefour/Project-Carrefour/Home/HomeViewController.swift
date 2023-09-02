//
//  HomeViewController.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 31/08/23.
//

import UIKit.UIViewController
import Alamofire
import Combine

protocol HomeDisplayLogic: AnyObject {
    func displayUsers(viewModel: Home.Users.ViewModel)
    func displayLoading(viewModel: Home.Loading.ViewModel)
    func displayErrorMessage(viewModel: Home.ErrorMessage.ViewModel)
}

class HomeViewController: UIViewController,
                          HomeDisplayLogic {
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    lazy var loaderActivityView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
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
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        
        Task {
            try await interactor?.requestUsers(request: .init(endpoint: "users"))
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(loaderActivityView)
        view.addSubview(searchBarView)
        view.addSubview(informationTableView)
        
        setupConstraints()
    }
    
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
            informationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            informationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            informationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
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
        
    }
}

extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = usersData else {
            return 0
        }
        
        if isSearchActive {
            guard let searchData = filteredSearch else {
                return 0
            }
            
            return searchData.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as! UsersTableViewCell

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
            AF.download(usersData![indexPath.row].avatarURL)
                .downloadProgress {
                    progress in
                    
                }
                .responseData { response in
                    if let data = response.value {
                        cell.avatarImageView.image = UIImage(data: data)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       router?.navigateToInformation(source: self, destination: InformationViewController())
    }
}

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
            informationTableView.reloadData()
        }
    }
}
