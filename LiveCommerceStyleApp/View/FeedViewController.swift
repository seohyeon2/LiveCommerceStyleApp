//
//  FeedViewController.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/08.
//

import UIKit

final class FeedViewController: UIViewController {
    private let feedView = FeedView()
    private let viewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(feedView)
        configureUI()
        configureCollectionView()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        
        
    }
    
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            feedView.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
            ),
            feedView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            feedView.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
            ),
            feedView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    private func configureCollectionView() {
        feedView.allUserPostCollectionView.delegate = self
        feedView.allUserPostCollectionView.dataSource = self
        feedView.allUserPostCollectionView.register(
            AllUserPostCollectionViewCell.self,
            forCellWithReuseIdentifier: AllUserPostCollectionViewCell.reuseIdentifier
        )
    }
    
    private func bind() {
        viewModel.contentCount.bind { [weak self] contentCount in
            VideoManager.shared.makeItems(count: contentCount)
            DispatchQueue.main.async {
                self?.feedView.allUserPostCollectionView.reloadData()
            }
        }
        
        viewModel.currentCount.bind { row in
            VideoManager.shared.play(
                row: row,
                column: 0
            )
        }
        
        viewModel.isError.bind { [weak self] isError in
            if isError {
                DispatchQueue.main.async {
                    self?.feedView.action = {
                        self?.viewModel.fetch()
                    }
                    self?.feedView.showRetryButton()
                }
            } else {
                DispatchQueue.main.async {
                    self?.feedView.removeRetryButton()
                }
            }
        }
    }
    
    private func isVideoFileExtension(url: String) -> Bool {
        let fileExtension = url.components(separatedBy: ".").last
        
        if fileExtension == "mp4" {
            return true
        }
        
        return false
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.contentCount.value
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AllUserPostCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? AllUserPostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        VideoManager.shared.resetPlayerItem()
        
        cell.currentIndex = indexPath.row
        
        VideoManager.shared.makeItems(count: 3)
        let contents = viewModel.posts[indexPath.row].contents
        
        if contents.count == 1 {
            cell.userPostPageControl.isHidden = true
        } else {
            cell.userPostPageControl.isHidden = false
            cell.userPostPageControl.numberOfPages = contents.count
        }
        
        Task {
            for (index, content) in contents.enumerated() {
                guard let profileData = await viewModel.loadImage(url: viewModel.posts[indexPath.row].influencer.profileThumbnailURL) else {
                    print("🔥\(NetworkingError.noData)")
                    return
                }
                
                if content.type == ContentType.image.name {
                    VideoManager.shared.addPlayerItem(
                        for: nil,
                        in: indexPath.row
                    )
                    
                    if isVideoFileExtension(url: content.contentURL) == true {
                        cell.setupErrorView(
                            profileData: profileData,
                            post: viewModel.posts[indexPath.row]
                        )
                    } else {
                        guard let postData = await viewModel.loadImage(url: content.contentURL) else {
                            return
                        }
                        
                        cell.setupImageView(
                            imageData: postData,
                            profileData: profileData,
                            post: viewModel.posts[indexPath.row]
                        )
                    }
                } else {
                    if isVideoFileExtension(url: content.contentURL) == false {
                        VideoManager.shared.addPlayerItem(
                            for: nil,
                            in: indexPath.row
                        )
                        
                        cell.setupErrorView(
                            profileData: profileData,
                            post: viewModel.posts[indexPath.row]
                        )
                    } else {
                        cell.setupVideoView(
                            url: content.contentURL,
                            row: indexPath.row,
                            column: index,
                            post: viewModel.posts[indexPath.row],
                            profileData: profileData
                        )
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = Int(
            max(
                0,
                scrollView.contentOffset.y / (UIScreen.main.bounds.height-93)
            )
        )
        viewModel.changeCurrentCount(count)
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > (contentHeight - scrollView.frame.height) {
            viewModel.fetch()
        }
        
        let visibleCells = feedView.allUserPostCollectionView.visibleCells
        
        for cell in visibleCells {
            guard let postCell = cell as? AllUserPostCollectionViewCell else {
                return
            }
            
            let cellHeight = cell.frame.size.height
            let collectionViewOffsetY = feedView.allUserPostCollectionView.contentOffset.y
            let nextCellTopLocation = cellHeight * CGFloat(viewModel.currentCount.value + 1)
            
            
            if postCell.userPostStackView.arrangedSubviews.isEmpty {
                return
            }
            
            if let postView = postCell.userPostStackView.arrangedSubviews[0] as? PostView {
                if collectionViewOffsetY < nextCellTopLocation {
                    postView.setupAlpha(
                        max(
                            0,
                            1 - (collectionViewOffsetY / nextCellTopLocation)
                        )
                    )
                }
                
                if collectionViewOffsetY == cellHeight * CGFloat(viewModel.currentCount.value) {
                    postView.setupAlpha(1)
                }
            }
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height-93
        )
    }
}
