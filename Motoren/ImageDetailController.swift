//
//  ImageDetailController.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit

class ImageDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var imageToDisplay : Image!
    public var comments : Array<DatabaseComment> = []
    
    public var commentDatabaseManager : ICommentDatabaseManager!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.delegate = self
        commentTable.dataSource = self
        descriptionLabel.text = imageToDisplay.description
        title = imageToDisplay.title
        loadImageAsync(imageToDisplay.imageUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reviewController = segue.destination as! ReviewController
        reviewController.uploadId = imageToDisplay.id
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.commentLabel.text = comment.text
        cell.usernameLabel.text = comment.author.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, om HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: comment.dateCreated)
        
        return cell
    }
    
    private func loadComments () {
        commentDatabaseManager.retrieveByUploadId(uploadId: imageToDisplay.id) { (comments, error) in
            self.comments = comments
            self.commentTable.reloadData()
        }
    }
    
    private func loadImageAsync(_ imageUrl : String) {
        DispatchQueue.global().async {
            let image = try! UIImage.init(data: Data.init(contentsOf: URL.init(string: imageUrl)!))
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.imageView.frame.size.height = image!.determineHeight(frameWidth: self.imageView.frame.width)
                self.view.layoutIfNeeded()
            }
        }
    }
}
