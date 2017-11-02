//
//  Image.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//
import UIKit

class UploadImage {
    
    public let title : String
    public let description : String
    public let author : Author
    private let image : UIImage?
    
    init(title : String?, description : String?, image : UIImage?, author : Author) {
        self.title = title ?? ""
        self.description = description ?? ""
        self.image = image
        self.author = author
    }
    
    public func validate() -> ValidationResult {
        let validationResult = ValidationResult()
        
        try! validationResult.addRegEx(field : "title", value : title, pattern : "[^\\s].{4,49}", errorMessage: "De titel moet tussen de 5 - 50 tekens bestaan.")
        
        try! validationResult.addRegEx(field : "description", value : description, pattern : "[^\\s].{0,499}", errorMessage: "De omschrijving mag niet meer dan 500 tekens bevatten.")
        
        try! validationResult.addCustom(field : "image", value : image as Any, errorMessage : "De afbeelding moet minimaal een grootte hebben van 200x200.") { (data) in
            let convertedImage = data as? UIImage
            
            if let image = convertedImage {
                return image.size.width >= 200 && image.size.height >= 200
            }
            
            return false
        }
        
        return validationResult
    }
}
