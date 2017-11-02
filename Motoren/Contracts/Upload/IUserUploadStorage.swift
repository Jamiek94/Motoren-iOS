//
//  IUserUploadStorage.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit

protocol IUserUploadStorage {
    
    func upload(_ image : UIImage, callback : @escaping (StorageMetadata?, Error?) -> Void)
    
}
