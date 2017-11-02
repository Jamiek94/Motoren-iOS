//
//  UserUploadDatabase.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import FirebaseFirestore

class UserUploadDatabase : IUserUploadDatabase {
    
    private let collectionReference : CollectionReference
    
    init() {
        let defaultStore = Firestore.firestore()
        
        collectionReference = defaultStore.collection("Uploads")
    }
    
    public func insert(author : Author, title : String, description : String, imageUrl : String, callback : @escaping (String?, Error?) -> Void) {
        var reference: DocumentReference? = nil
        
        reference = collectionReference.addDocument(data: [
            "author" : [
                "id" : author.id,
                "name" : author.name
            ],
            "title": title,
            "description": description,
            "imageUrl": imageUrl,
            "amountLikes" : 0,
            "dateCreated" : FieldValue.serverTimestamp()
        ]) { (error) in
            callback(reference?.documentID, error)
        }
    }
}
