//
//  UsersTableViewCell.swift
//  Project-Carrefour
//
//  Created by Thiago dos Santos Martins on 01/09/23.
//

import UIKit.UITableViewCell
import Combine

class UsersTableViewCell: UITableViewCell {
    static let identifier = String(String(describing: UsersTableViewCell.self))
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 3
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = Asset.royal.color.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLink(_:)))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var link: String = "" {
        didSet {
            createLink(link)
        }
    }
    
    lazy var selectionImagView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrowshape.turn.up.right.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var linkSelected = PassthroughSubject<String, Never>()
    var linkData: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
  
        isUserInteractionEnabled = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(loginLabel)
        contentView.addSubview(urlLabel)
        contentView.addSubview(selectionImagView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            loginLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            loginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            urlLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            urlLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            urlLabel.trailingAnchor.constraint(equalTo: selectionImagView.leadingAnchor, constant: -10),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            selectionImagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            selectionImagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            selectionImagView.heightAnchor.constraint(equalToConstant: 30),
            selectionImagView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func createLink(_ data: String) {
        let attributedString = NSMutableAttributedString(string: data)
        let str = NSString(string: data)
        let theRange = str.range(of: data)
        
        attributedString.addAttribute(.link, value: data, range: theRange)

        urlLabel.attributedText = attributedString
    }
    
    @objc private func didTapLink(_ sender: UITapGestureRecognizer) {
        linkSelected.send(urlLabel.text!)
    }
}
