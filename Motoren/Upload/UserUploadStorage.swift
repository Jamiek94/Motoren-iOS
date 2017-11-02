//
//  UserUploadStorage.swift
//  Motoren
//
//  Created by Jamie Knoef on 29/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import FirebaseStorage
import UIKit

class UserUploadStorage : IUserUploadStorage {
    
    private let storageReference : StorageReference
    
    init() {
        let storage = Storage.storage()
        storageReference = storage.reference()
    }
    
    public func upload(_ image : UIImage, callback : @escaping (StorageMetadata?, Error?) -> Void) {
        let imageData = UIImagePNGRepresentation(resizeImage(image))!
        let nsImageData = NSData.init(data: imageData)
        
        let userUploadsReference = storageReference.child("User-Uploads/\(UUID().uuidString).\(nsImageData.imageFormat.rawValue)")
        
        userUploadsReference.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return callback(nil, error)
            }
            
            return callback(metadata, nil)
        }
    }
    
    private func resizeImage(_ image : UIImage) -> UIImage {
        return image.resize(width: 960)
    }
    
}
