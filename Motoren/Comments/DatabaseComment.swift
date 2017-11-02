//
//  DatabaseComment.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation

class DatabaseComment : Comment {
    
    init(uploadId : String, id : String, author : Author, text : String, timestampCreated : Double) {
        self.id = id
        self.timestampCreated = timestampCreated
        super.init(uploadId : uploadId, author : author, text: text)
    }
    
    convenience init (id : String, timestampCreated : Double, comment : Comment) {
        self.init(uploadId : comment.uploadId, id: id, author : comment.author, text: comment.text, timestampCreated: timestampCreated)
    }
    
    public let id : String
    public var dateCreated : Date {
        get {
            return Date(timeIntervalSince1970: timestampCreated)
        }
    }
    
    public let timestampCreated : Double
}
