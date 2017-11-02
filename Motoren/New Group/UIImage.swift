//
//  UIImage.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//
import UIKit
import Foundation

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        return create(image: self, size: newSize)
    }
    
    func resize(width by : CGFloat) -> UIImage {
        let ratio = min(self.size.width, by) / max(self.size.width, by)
        
        let newHeight = self.size.height * ratio
        
        return create(image: self, size: CGSize.init(width: by, height: newHeight))
    }
    
    public func determineHeight(frameWidth : CGFloat) -> CGFloat {
        let imageRatio = min(self.size.width, self.size.width) / max(self.size.width, self.size.height)
        
        return frameWidth * imageRatio
    }
    
    private func create(image : UIImage, size : CGSize) -> UIImage {
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
