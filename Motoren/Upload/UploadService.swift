//
//  UploadService.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth

class UploadService : IUploadService {
    
    private let userUploadStorage : IUserUploadStorage
    private let userUploadDatabase : IUserUploadDatabase
    
    init(userUploadStorage : IUserUploadStorage, userUploadDatabase : IUserUploadDatabase) {
        self.userUploadStorage = userUploadStorage
        self.userUploadDatabase = userUploadDatabase
    }
    
    public func upload(author : Author, title : String?, description : String?, image : UIImage?, callback : @escaping (Image?, ValidationResult, Error?) -> Void) {
        let imageToUpload = UploadImage(title: title, description: description, image: image, author: author)
        
        let validationResult = imageToUpload.validate()
        
        guard validationResult.isValid else {
            callback(nil, validationResult, nil)
            return
        }
        
        DispatchQueue.global().async {
            self.userUploadStorage.upload(image!) { (storageMetaData, error) in
                guard error == nil else {
                    callback(nil, validationResult, error)
                    return
                }
                
                let imageUrl = storageMetaData!.downloadURL()!.absoluteString
                
                self.userUploadDatabase.insert(author : author, title: title!, description: description!, imageUrl: imageUrl, callback: { (documentId, error) in
                    
                    guard error == nil else {
                        callback(nil, validationResult, error)
                        return
                    }
                    
                    let user = Auth.auth().currentUser!
                    let uploadedImage = Image.init(with: imageToUpload, id : documentId!, imageUrl: imageUrl, author: Author.init(id: user.uid, name: user.displayName!))
                    
                    DispatchQueue.main.async {
                        callback(uploadedImage, validationResult, error)
                    }
                })
            }
        }
    }
}
