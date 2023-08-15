//
//  PostView.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/13.
//

import UIKit
import AVFoundation

final class PostView: UIView {
    private var type: ContentType?
    private var isClose = true

    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let postVideoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 25,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "heart.fill",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let followerButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 25,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "person.crop.circle",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 25,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "ellipsis",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 25,
            weight: .light
        )
        imageView.image = UIImage(
            systemName: "face.smiling.inverse",
            withConfiguration: imageConfig
        )
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userIDLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .lastBaseline
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 16,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "chevron.down",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userInfoDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
    }
    
    convenience init(type: ContentType) {
        self.init(frame: CGRect())
        self.type = type
        
        if type == ContentType.image {
            configurePostImageView()
        } else {
            configurePostVideoView()
        }
        
        registerButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(post: Post) {
        userIDLabel.text = post.influencer.displayName
        descriptionLabel.text = post.description
        likeLabel.text = post.likeCount.getConvertedNumber()
        followerLabel.text = post.influencer.followCount.getConvertedNumber()
    }
    
    func setupProfile(_ data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        userImageView.image = image
        userImageView.heightAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
        userImageView.widthAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
        userImageView.layer.cornerRadius = 20
        userImageView.clipsToBounds = true
    }
    
    func setupAlpha(_ alpha: CGFloat) {
        buttonStackView.alpha = alpha
        userInfoStackView.alpha = alpha
        descriptionStackView.alpha = alpha
    }
    
    private func configurePostVideoView() {
        addSubview(postVideoView)
        NSLayoutConstraint.activate([
            postVideoView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            postVideoView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            postVideoView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            postVideoView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            )
        ])
        
        configureCommonView()
        configureCommonUI()
    }
    
    private func configurePostImageView() {
        addSubview(postImageView)
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            postImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            postImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            postImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            )
        ])
        
        configureCommonView()
        configureCommonUI()
    }
    
    private func configureCommonView() {
        self.backgroundColor = .black
        
        addSubview(buttonStackView)
        addSubview(userInfoDescriptionStackView)
        
        buttonStackView.addArrangedSubview(likeStackView)
        buttonStackView.addArrangedSubview(followerStackView)
        buttonStackView.addArrangedSubview(moreButton)
        
        likeStackView.addArrangedSubview(likeButton)
        likeStackView.addArrangedSubview(likeLabel)
        
        followerStackView.addArrangedSubview(followerButton)
        followerStackView.addArrangedSubview(followerLabel)
        
        userInfoDescriptionStackView.addArrangedSubview(userInfoStackView)
        userInfoDescriptionStackView.addArrangedSubview(descriptionStackView)
        
        userInfoStackView.addArrangedSubview(userImageView)
        userInfoStackView.addArrangedSubview(userIDLabel)
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionButton)
    }

    private func configureCommonUI() {
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 450
            ),
            buttonStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            buttonStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -100
            ),
        
            userInfoDescriptionStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            userInfoDescriptionStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -30
            ),
            userInfoDescriptionStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -150
            )
        ])
    }
    
    private func registerButtonAction() {
        descriptionButton.addTarget(
            self,
            action: #selector(didTapDescriptionButton),
            for: .touchUpInside
        )
    }
    
    @objc func didTapDescriptionButton() {
        if isClose {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            isClose.toggle()
        } else {
            descriptionLabel.numberOfLines = 2
            isClose.toggle()
        }
    }
}
