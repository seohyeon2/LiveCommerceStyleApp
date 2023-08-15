//
//  FeedView.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import UIKit

final class FeedView: UIView {
    var action: (() -> Void)?
    let allUserPostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 100,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "arrow.triangle.2.circlepath.circle.fill",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tag = 100
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let soundButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 25,
            weight: .light
        )
        button.setImage(
            UIImage(
                systemName: "speaker.wave.2.fill",
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white

        configureView()
        configureUI()
        registerSoundButtonAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRetryButton() {
        addSubview(retryButton)
        retryButton.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        retryButton.centerYAnchor.constraint(
            equalTo: centerYAnchor
        ).isActive = true
    }
    
    func removeRetryButton() {
        self.viewWithTag(100)?.removeFromSuperview()
    }
    
    private func configureView() {
        addSubview(allUserPostCollectionView)
        addSubview(soundButton)
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            allUserPostCollectionView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            allUserPostCollectionView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),

            allUserPostCollectionView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            ),
            allUserPostCollectionView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            
            soundButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 30
            ),
            soundButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            )
        ])
    }
    
    private func registerSoundButtonAction() {
        soundButton.addTarget(
            self,
            action: #selector(didTapSoundButton),
            for: .touchUpInside
        )
        
       retryButton.addTarget(
            self,
            action: #selector(didTapRetryButton),
            for: .touchUpInside
        )
    }
    
    @objc func didTapSoundButton() {
        if !VideoManager.shared.isVideoType() {
            return
        }
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        var imageName = ""
        if VideoManager.shared.isMuted() {
            imageName = "speaker.slash.fill"
        } else {
            imageName = "speaker.wave.2.fill"
        }
        
        soundButton.setImage(
            UIImage(systemName: imageName, withConfiguration: imageConfig),
            for: .normal
        )
    }
    
    @objc func didTapRetryButton() {
        guard let action = action else {
            return
        }
        
        action()
        removeRetryButton()
    }
}
