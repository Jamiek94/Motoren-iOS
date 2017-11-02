//
//  IImageManager.swift
//  Motoren
//
//  Created by Jamie Knoef on 01/11/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import Foundation

protocol IImageManager {
    
    func retrieve(limit : Int, callback: @escaping (Array<Image>, Error?) -> Void)
    
}
