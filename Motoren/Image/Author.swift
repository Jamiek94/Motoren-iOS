//
//  Author.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import FirebaseAuth

class Author {
    
    public let name : String
    public let id : String
    
    init(id : String, name : String) {
        self.id = id
        self.name = name
    }
    
    convenience init(user : User) {
        self.init(id: user.uid, name: user.displayName!)
    }
    
}
