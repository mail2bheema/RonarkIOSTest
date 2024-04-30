//
//  ViewController.swift
//  Assessment
//
//  Bheema Badri on 29/04/24.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = PostsViewModel()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Posts"
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = createLoadMoreFooterView()
        fetchPosts()
    }
    
    func fetchPosts() {
        viewModel.fetchPosts {
            self.tableView.reloadData()
        }
    }
    
    func createLoadMoreFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let loadMoreButton = UIButton(type: .system)
        loadMoreButton.frame = CGRect(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height)
        loadMoreButton.setTitle("Load More", for: .normal)
        loadMoreButton.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
        footerView.addSubview(loadMoreButton)
        return footerView
    }
    
    @objc func loadMoreTapped() {
        fetchPosts()
    }

}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.accessoryType = .detailButton
        let post = viewModel.posts[indexPath.row]
        cell.idLabel?.text = "ID: \(post.id)"
        cell.titleLabel?.text = post.title
        return cell
    }
}

extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = viewModel.posts[indexPath.row]

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailPostViewController = storyBoard.instantiateViewController(withIdentifier: "detailPostViewController") as! DetailPostViewController
        detailPostViewController.post = post
        self.navigationController?.pushViewController(detailPostViewController,animated:true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.size.height
        if offsetY > contentHeight - boundsHeight {
            viewModel.loadMorePostsIfNeeded(for: IndexPath(row: viewModel.posts.count - 1, section: 0)) {
                self.tableView.reloadData()
            }
        }
    }
}
