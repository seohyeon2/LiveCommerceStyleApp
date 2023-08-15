//
//  AllUserPostCollectionViewCell.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import UIKit

final class AllUserPostCollectionViewCell: UICollectionViewCell, Identifiable {
    var currentIndex = 0
    private var postView = PostView(type: .image)
    
    let userPostPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height-113,
            width: UIScreen.main.bounds.width,
            height: 20
        )
        return pageControl
    }()
    
    let userPostStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userPostScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(3),
            height: UIScreen.main.bounds.height
        )
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupErrorView(
        profileData: Data,
        post: Post
    ) {
        VideoManager.shared.pause()
        postView = PostView(type: .image)
        postView.postImageView.image = UIImage(named: "errorImage")
        postView.postImageView.contentMode = .scaleAspectFit
        postView.setupLabel(post: post)
        postView.setupProfile(profileData)

        addUserPostStackView(postView)
    }
    
    func setupImageView(
        imageData: Data,
        profileData: Data,
        post: Post
    ) {
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        postView = PostView(type: .image)
        postView.postImageView.image = image
        postView.setupLabel(post: post)
        postView.setupProfile(profileData)

        if image.size.width >= image.size.height {
            postView.postImageView.contentMode = .scaleAspectFit
        }

        addUserPostStackView(postView)
    }
    
    func setupVideoView(
        url: String,
        row: Int,
        column: Int,
        post: Post,
        profileData: Data
    ) {
        guard let url = URL(string: url) else {
            return
        }
        
        VideoManager.shared.addPlayerItem(
            for: url,
            in: row
        )

        let playerLayer = VideoManager.shared.getPlayerLayer(
            row: row,
            column: column
        )
        playerLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        playerLayer.videoGravity = .resizeAspectFill
        
        postView = PostView(type: .video)
        postView.postVideoView.layer.addSublayer(playerLayer)
        postView.setupLabel(post: post)
        postView.setupProfile(profileData)
        
        addUserPostStackView(postView)
        
        if currentIndex == 0 {
            VideoManager.shared.play(row: row, column: 0)
        }
    }
    
    private func addUserPostStackView(_ myView: UIView) {
        userPostStackView.addArrangedSubview(myView)
        
        myView.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width
        ).isActive = true
    }
    
    private func configureView() {
        addSubview(userPostScrollView)
        addSubview(userPostPageControl)
        
        userPostScrollView.addSubview(userPostStackView)
        userPostScrollView.delegate = self
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            userPostScrollView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            userPostScrollView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            userPostScrollView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            userPostScrollView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            
            userPostStackView.leadingAnchor.constraint(
                equalTo: userPostScrollView.contentLayoutGuide.leadingAnchor
            ),
            userPostStackView.trailingAnchor.constraint(
                equalTo: userPostScrollView.contentLayoutGuide.trailingAnchor
            ),
            userPostStackView.topAnchor.constraint(
                equalTo: userPostScrollView.frameLayoutGuide.topAnchor
            ),
            userPostStackView.bottomAnchor.constraint(
                equalTo: userPostScrollView.frameLayoutGuide.bottomAnchor
            )
        ])
    }
    
    override func prepareForReuse() {
        userPostPageControl.numberOfPages = 0
        userPostStackView.removeAllArrangedSubview()
    }
}

extension AllUserPostCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        userPostPageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        
        VideoManager.shared.resetPlayerItem()
        VideoManager.shared.play(
            row: currentIndex,
            column: userPostPageControl.currentPage
        )

        let viewWidth = UIScreen.main.bounds.width
        let scrollViewOffsetX = scrollView.contentOffset.x
        let nextViewLeadingLocation = viewWidth * CGFloat(userPostPageControl.currentPage + 1)
        
        if userPostStackView.arrangedSubviews.isEmpty {
            return
        }
    
        guard let postView = userPostStackView.arrangedSubviews[userPostPageControl.currentPage] as? PostView else {
            return
        }

        if scrollViewOffsetX < nextViewLeadingLocation {
            postView.setupAlpha(
                max(
                    0,
                    1 - (scrollViewOffsetX / nextViewLeadingLocation)
                )
            )
        }

        if scrollViewOffsetX == viewWidth * CGFloat(userPostPageControl.currentPage) {
            postView.setupAlpha(1)
        }
    }
}
