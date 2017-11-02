//
//  SwinjectStoryboard.swift
//  Motoren
//
//  Created by Jamie Knoef on 30/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.register(IUserUploadDatabase.self) { _ in UserUploadDatabase() }
        defaultContainer.register(IUserUploadStorage.self) { _ in UserUploadStorage() }
        defaultContainer.register(IUploadService.self) { r in UploadService(userUploadStorage : r.resolve(IUserUploadStorage.self)!, userUploadDatabase : r.resolve(IUserUploadDatabase.self)!) }
        defaultContainer.register(ICommentDatabaseManager.self) { _ in CommentDatabaseManager() }
        defaultContainer.register(IImageManager.self) { _ in ImageManager() }
        
        defaultContainer.storyboardInitCompleted(UploadImageController.self) { r, controller  in
            controller.uploadService = r.resolve(IUploadService.self)
        }
        
        defaultContainer.storyboardInitCompleted(ImagesOverviewTableController.self) { r, controller  in
            controller.imageManager = r.resolve(IImageManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(ReviewController.self) { r, controller  in
            controller.commentDatabaseManager = r.resolve(ICommentDatabaseManager.self)
        }
        
    }
}
