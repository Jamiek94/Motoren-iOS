//
//  ImageManager.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ImageManager : IImageManager {
    
    private let collectionReference : CollectionReference
    
    init() {
        let defaultStore = Firestore.firestore()
        
        collectionReference = defaultStore.collection("Uploads")
    }
    
    public func retrieve(limit : Int, callback: @escaping (Array<Image>, Error?) -> Void) {
        collectionReference
            .order(by: "dateCreated", descending : true)
            .limit(to: limit)
            .getDocuments { (query, error) in
                if error != nil {
                    callback([], error)
                    return
                }
                
                let images = query!.documents.map({ (document) -> Image in
                    return Image.init(document : document)
                })
                
                callback(images, error)
        }
    }
    
}
