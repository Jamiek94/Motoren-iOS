//
//  ImageCommentsDatabase.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class CommentDatabaseManager : ICommentDatabaseManager {
    
    private let collectionReference : CollectionReference
    
    init() {
        let defaultStore = Firestore.firestore()
        
        collectionReference = defaultStore.collection("UploadComments")
    }
    
    public func addComment(comment : Comment, callback : @escaping (DatabaseComment?, Error?) -> Void) {
        var reference : DocumentReference? = nil
        reference = collectionReference.addDocument(data: [
            "uploadId" : comment.uploadId,
            "author" : [
                "id" : comment.author.id,
                "name" : comment.author.name
            ],
            "text" : comment.text,
            "dateCreated" : FieldValue.serverTimestamp()
        ]) { (error) in
            if error != nil {
                callback(nil, error)
                return
            }
            
            let dbComment = DatabaseComment.init(id: reference!.documentID, timestampCreated : Date().timeIntervalSince1970, comment: comment)
            
            callback(dbComment, error)
        }
    }
    
    public func retrieveByUploadId(uploadId : String, callback : @escaping (Array<DatabaseComment>, Error?) -> Void) {
        collectionReference
            .whereField("uploadId", isEqualTo: uploadId)
            .order(by: "date", descending : true)
            .getDocuments { (query, error) in
                if error != nil {
                    callback([], error)
                    return
                }
                
                let comments = query!.documents.map({ (document) -> DatabaseComment in
                    let data = document.data()
                    let queryAuthor = data["author"] as! Dictionary<String, String>
                    let author = Author.init(id: queryAuthor["id"]!, name: queryAuthor["name"]!)
                    return DatabaseComment.init(uploadId: uploadId, id: document.documentID, author : author, text: data["text"] as! String, timestampCreated: data["dateCreated"] as! Double)
                })
                
                callback(comments, error)
        }
        
    }
}
