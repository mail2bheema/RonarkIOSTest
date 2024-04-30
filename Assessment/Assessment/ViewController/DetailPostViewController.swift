//
//  DetailPostViewController.swift
//  Assessment
//
//  Created by Admin on 29/04/24.
//

import UIKit

class DetailPostViewController: UIViewController {
    @IBOutlet weak var detailText: UILabel!
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail Post"
        detailText.text = post?.title
    }
    
}
