//
//  IUploadService.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation
import UIKit

protocol IUploadService {
    
    func upload(author : Author, title : String?, description : String?, image : UIImage?, callback : @escaping (Image?, ValidationResult, Error?) -> Void)
    
}
