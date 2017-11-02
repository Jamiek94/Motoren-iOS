//
//  ImagesOverviewTableController.swift
//  Motoren
//
//  Created by Jamie Knoef on 29/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit

class ImagesOverviewTableController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias OverViewImage = (image : Image, height : CGFloat)
    
    public var images : Array<OverViewImage> = []
    public var cachedImages : Dictionary<String, UIImage> = [:]
    public var imageManager : IImageManager!
    private var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(onHeaderAddImage))
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        
        imageManager.retrieve(limit: 100) { (images, error) in
            print("retrieving")
            self.images = images.map({ (image) -> OverViewImage in
                return (image : image, height : self.tableView.estimatedRowHeight)
            })
            self.tableView.reloadData()
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView,
     heightForRowAt indexPath: IndexPath) -> CGFloat {
     let upload = images[indexPath.row]
     
     return upload.height
     } */
    
    @IBAction func onHeaderAddImage(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Locatie", message: "Selecteer een locatie", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
            self.showImageSource(.camera)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Gallerij", style: UIAlertActionStyle.default, handler: { (action) in
            self.showImageSource(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Annuleren", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = (info["UIImagePickerControllerOriginalImage"] as! UIImage)
        
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "UploadSegue", sender: nil)
        }
    }
    
    private func showImageSource(_ source : UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        
        self.present(imagePickerController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overview", for: indexPath) as! OverviewCell
        
        let upload = images[indexPath.row]
        
        cell.titleLabel.text = upload.image.title
        
        let cachedImage = cachedImages[upload.image.imageUrl]
        
        if let cachedImage = cachedImage {
            var cellFrame = cell.frame.size
            cellFrame.width = cellFrame.width - 30
            
            let resizedImage = cachedImage.resize(width: cellFrame.width)
            
            cell.imageView!.image = resizedImage
            
            //cell.heightConstrain.constant = resizedImage.size.height
        }
        else {
            
            DispatchQueue.global().async {
                let data = try! Data.init(contentsOf: URL.init(string: upload.image.imageUrl)!)
                
                DispatchQueue.main.sync {
                    self.cachedImages[upload.image.imageUrl] = UIImage.init(data:data)!
                    
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    self.tableView.endUpdates()
                    
                }
                
            }
        }
        
        
        /*
         
         guard cachedImages[upload.image.imageUrl] != nil else {
         DispatchQueue.global().async {
         let image = try! UIImage.init(data: Data.init(contentsOf: URL.init(string: upload.image.imageUrl)!))!
         
         DispatchQueue.main.async {
         let contrainMargin : CGFloat = 30
         let spaceMarginTop : CGFloat = 30
         
         let resizedImage = image.resize(width: self.view.superview!.frame.size.width - contrainMargin)
         
         print("width: \(resizedImage.size.width), height: \(resizedImage.size.height)")
         
         self.cachedImages[upload.image.imageUrl] = resizedImage
         self.images[indexPath.row].height = resizedImage.size.height + cell.titleLabel.frame.size.height + spaceMarginTop
         
         let constrain = self.getAspectRatioAccordingToiPhones(cellImageFrame: cell.frame.size, downloadedImage: resizedImage)
         
         print(constrain)
         
         cell.heightConstrain.constant = constrain
         
         /*
         tableView.beginUpdates()
         tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
         tableView.endUpdates() */
         }
         }
         
         return cell
         }
         
         
         
         
         //print("determined height: \(image.determineHeight(frameWidth: self.view.frame.width))")
         //upload.height = image.determineHeight(frameWidth: self.view.frame.width)
         //cell.imageView!.setNeedsLayout()
         //cell.imageView!.layoutIfNeeded()
         //cell.setNeedsLayout()
         //cell.layoutIfNeeded()
         
         // tableView.beginUpdates()
         // tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
         // tableView.endUpdates()
         //  }
         //}
         */
        return cell
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uploadImageController = segue.destination as! UploadImageController
        
        uploadImageController.selectedImage = selectedImage
    }
    
}
