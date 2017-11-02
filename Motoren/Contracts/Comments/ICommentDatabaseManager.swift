//
//  CommentDatabaseManager.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation

protocol ICommentDatabaseManager {
    
    func addComment(comment : Comment, callback : @escaping (DatabaseComment?, Error?) -> Void)
    func retrieveByUploadId(uploadId : String, callback : @escaping (Array<DatabaseComment>, Error?) -> Void)
    
}
