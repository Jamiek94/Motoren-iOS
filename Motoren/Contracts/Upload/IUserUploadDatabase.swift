//
//  IUploadDatabase.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation

protocol IUserUploadDatabase {
    
    func insert(author : Author, title : String, description : String, imageUrl : String, callback : @escaping (String?, Error?) -> Void)
    
}
