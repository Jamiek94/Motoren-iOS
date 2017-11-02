//
//  ValidationResult.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//
import Foundation

class ValidationResult {
    
    private var errors = Dictionary<String, String>()
    
    public var isValid : Bool {
        get {
            return errors.count == 0
        }
    }
    
    public var isInvalid : Bool {
        get {
            return errors.count > 0
        }
    }
    
    public var errorMessages : Array<String> {
        get {
            return errors.map({ (key, value) -> String in
                return value
            })
        }
    }
    
    public func addRegEx(field : String, value : String?, pattern : String, errorMessage : String) throws {
        guard errors[field] == nil else {
            throw ValidationException.keyAlreadyExists
        }
        
        var isValid = false
        
        if let value = value {
            let regex = try! NSRegularExpression(pattern: pattern)
            
            isValid = regex.matches(in: value, options: [], range: NSRange(value.startIndex..., in : value)).count > 0
        }
        
        if !isValid {
            errors[field] = errorMessage
        }
    }
    
    public func addCustom(field : String, value : Any,  errorMessage : String, validator : (Any) -> Bool) throws {
        guard errors[field] == nil else {
            throw ValidationException.keyAlreadyExists
        }
        
        let isValid = validator(value)
        
        if !isValid {
            errors[field] = errorMessage
        }
    }
}
