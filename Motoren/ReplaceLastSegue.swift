//
//  ReplaceLastSegue.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit
import Foundation

class ReplaceLastSegue : UIStoryboardSegue {
    
    override func perform() {
        let destinationController = self.destination
        
        var controllerStack = self.source.navigationController!.viewControllers
        controllerStack[controllerStack.count - 1] = destinationController
        
        self.source.navigationController!.setViewControllers(controllerStack , animated: true)
    }
    
}
