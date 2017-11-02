//
//  Comment.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation

class Comment {
    
    init(uploadId : String, author : Author, text : String) {
        self.uploadId = uploadId
        self.author = author
        self.text = text
    }
    
    public let uploadId : String
    public let author : Author
    public let text : String
}
