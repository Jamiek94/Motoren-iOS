//
//  UploadImageController.swift
//  Motoren
//
//  Created by Jamie Knoef on 29/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit
import FirebaseAuth

class UploadImageController: UIViewController, UITextFieldDelegate {
    
    public var selectedImage : UIImage!
    public var uploadedImage : Image?
    public var uploadService : IUploadService!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        imageView.image = selectedImage
        descriptionView.createBorder()
        
        titleTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    @IBAction func onImageUpload(_ sender: UIBarButtonItem) {
        let progressHUD = ProgressHUD.init(text : "Uploaden...")
        progressHUD.show()
        view.addSubview(progressHUD)
        
        uploadService.upload(author : Author.init(user: Auth.auth().currentUser!), title : titleTextField.text, description: descriptionView.text, image: imageView.image) { (image, validationResult, error) in
            progressHUD.hide()
            progressHUD.removeFromSuperview()
            self.uploadedImage = image
            
            guard error == nil else {
                self.showAlert(title : "Foutmelding", message : "Kon de afbeelding niet uploaden. Heb je nog wel internet?")
                return
            }
          
            guard error == nil && validationResult.isValid else {
                self.showAlert(title: "Validatie fout", message: validationResult.errorMessages.joined(separator: "\n * "))
                return
            }
            
            if error == nil && validationResult.isValid {
              
                
                //navigationController!.setViewControllers(controllerStack, animated: true)
                
                self.performSegue(withIdentifier: "ImageDetail", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageDetailController = segue.destination as! ImageDetailController
        
        imageDetailController.imageToDisplay = uploadedImage!
    }
}
