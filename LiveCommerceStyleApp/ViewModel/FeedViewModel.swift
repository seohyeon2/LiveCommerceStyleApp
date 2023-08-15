//
//  FeedViewModel.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/09.
//

import Foundation

final class FeedViewModel {
    private(set) var currentCount: Observable<Int> = Observable(0)
    private(set) var posts = [Post]()
    private(set) var contentCount: Observable<Int> = Observable(0)
    private(set) var isError: Observable<Bool> = Observable(false)
    private var page = 1
    private let networkManager = NetworkManager()
    
    func fetch() {
        let apiRequest = ShopRequest(
            baseURL: BaseURL.dev,
            method: HTTPMethod.get,
            path: Path.posts,
            queries: ["page" : "$\(page)"]
        )
        networkManager.dataTask(api: apiRequest) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data,
                      let feed = JSONManager.shared.decode(type: Feed.self, from: data) else {
                    self?.isError.value = true
                    print("🔥\(JSONDecodeError.decodingError)")
                    return
                }
                
                feed.posts.forEach {
                    self?.posts.append($0)
                }

                self?.contentCount.value += feed.count
                self?.page += 1
                self?.isError.value = false

            case .failure(let error):
                self?.isError.value = true
                print("🔥\(error)")
            }
        }
    }
    
    func loadImage(url: String) async -> Data? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        let data = Task {
            return try? Data(contentsOf: url)
        }
        
        guard let imageData = await data.value else {
            return nil
        }

        return imageData
    }
    
    func changeCurrentCount(_ count: Int) {
        currentCount.value = count
    }
}
