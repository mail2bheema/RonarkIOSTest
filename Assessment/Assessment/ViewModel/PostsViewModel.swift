//
//  PostsViewModel.swift
//  Assessment
//
//  Created by Admin on 29/04/24.
//

import Foundation

class PostsViewModel {
    
    var posts: [Post] = []
    private var currentPage = 1
    private let perPage = 10
    private var isLoading = false
    private var url = "https://jsonplaceholder.typicode.com/posts?_page="
    
    func fetchPosts(completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        let urlString = "\(url)\(currentPage)&_limit=\(perPage)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let newPosts = try JSONDecoder().decode([Post].self, from: data)
                self?.posts.append(contentsOf: newPosts)
                self?.isLoading = false
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func loadMorePostsIfNeeded(for indexPath: IndexPath, completion: @escaping () -> Void) {
        let threshold = 5
        if indexPath.row >= posts.count - threshold {
            currentPage += 1
            fetchPosts {
                completion()
            }
        }
    }
}
