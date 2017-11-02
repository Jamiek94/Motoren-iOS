//
//  Image.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Image {
    
    public let id : String
    public let title : String
    public let description : String
    public let imageUrl : String
    public let amountLikes : Int
    public let author : Author
    public let dateCreated : Date
    
    init(id : String, title : String, description : String, imageUrl : String, amountLikes : Int, dateCreated: Double, author : Author) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.amountLikes = amountLikes
        self.author = author
        self.dateCreated = Date.init(timeIntervalSince1970: dateCreated)
    }
    
    convenience init (document : DocumentSnapshot) {
        let databaseRecord = document.data()
        let authorDictionary = document["author"] as! Dictionary<String, String>
        let author = Author.init(id : authorDictionary["id"]!, name : authorDictionary["name"]!)
        self.init(id: document.documentID, title: databaseRecord["title"] as! String, description : databaseRecord["description"] as! String, imageUrl: databaseRecord["imageUrl"] as! String,
                  amountLikes: databaseRecord["amountLikes"] as! Int, dateCreated : (databaseRecord["dateCreated"] as! Date).timeIntervalSince1970, author: author)
    }
    
    convenience init (with uploadImage : UploadImage, id : String, imageUrl : String, author : Author) {
        self.init(id : id, title : uploadImage.title, description : uploadImage.description, imageUrl: imageUrl, amountLikes : 0, dateCreated : Date().timeIntervalSince1970, author : author)
    }
}
