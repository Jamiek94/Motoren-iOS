//
//  ReviewController.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class ReviewController: UIViewController {
    
    public var uploadId : String!
    public var commentDatabaseManager : ICommentDatabaseManager!

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.createBorder()
    }
    
    @IBAction func onAddComment(_ sender: UIBarButtonItem) {
        let user = Auth.auth().currentUser!
        let comment = Comment.init(uploadId: uploadId, author : Author.init(user : user), text: textView.text)
        let progressHUD = ProgressHUD.init(text: "Laden...")
        
        view.addSubview(progressHUD)
        
        progressHUD.show()
        
        commentDatabaseManager.addComment(comment: comment) { (comment, error) in
            progressHUD.hide()
            progressHUD.removeFromSuperview()
            
            if error != nil {
                self.showAlert(title: "Foutmelding", message: "Kon de reactie niet toevoegen.")
            } else {
                let previousController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2]
                self.navigationController!.popViewController(animated: true)
                previousController.view.makeToast("Reactie toegevoegd", duration: 3.0, position: .bottom)
            }
           
        }
    }

}
