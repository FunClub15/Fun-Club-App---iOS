//
//  User.swift
//  FunClub
//
//  Created by Usman Khalil on 16/06/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import CoreData

class User: NSObject {
    
    private var instance: User?
    
    var canvasColor: UIColor?
    var profileImage: UIImage?
    var dashboardImages = [Any]()
    
    
    var id:String = ""
    var name:String = ""
    var username:String = ""

    var email:String = ""
    var gender:String = ""
    var picture:String = ""
    var type:String = ""
    var phoneNumber:String = ""
   
    
    
//    class func sharedInstance() -> Self {
//        var onceToken: Int
//        if (onceToken == 0) {
//            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
//            instance = User()
//        }
//        onceToken = 1
//        return instance
//    }
//
    
    func isLogin() -> Bool {
        return (id != "" && id != "0")
    }
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    // Add new image to dashboard
    func create(imageName: String) -> UserDashboardImages {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "UserDashboardImages", into: context) as! UserDashboardImages
        
        newItem.imageName = imageName
        
        return newItem
    }
    
    func createImageData(imageData: Data, imageId: String) -> UserDashboardImages {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "UserDashboardImages", into: context) as! UserDashboardImages
        
        newItem.imageData = imageData as NSData
        newItem.imageId = imageId as String
        do {
            try self.context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        return newItem
    }
    
    // Gets a person by id
    func getById(id: NSManagedObjectID) -> UserDashboardImages? {
        return context.object(with: id) as? UserDashboardImages
    }
    
    // Gets all.
    func getAll() -> [UserDashboardImages]{
        return get(withPredicate: NSPredicate(value:true))
    }
    func get(withPredicate queryPredicate: NSPredicate) -> [UserDashboardImages]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDashboardImages")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [UserDashboardImages]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [UserDashboardImages]()
        }
    }

    // Deletes a person
    func deleteImage(id: NSManagedObjectID){
        if let personToDelete = getById(id: id){
            context.delete(personToDelete)
        }
//        let fetchRequest: NSFetchRequest<UserDashboardImages> = UserDashboardImages.fetchRequest()
//        fetchRequest.predicate = NSPredicate.init(format: "imageID==\(id)")
//        let object = try! context.fetch(fetchRequest)
//        context.delete(object)
//        
//        do {
//            try context.save() // <- remember to put this :)
//        } catch {
//            // Do something... fatalerror
//        }
    }

    
//    // MARK: dashboardImages
//    func setDashboardImages(_ images: [Any]){
//        dashboardImages = images
//        UserDefaults.standard.setValue(images, forKey: "DashboardImages")
//    }
//    
//    func dashboardImages() -> [Any] {
//        var images = UserDefaults.standard.value(forKey: "DashboardImages") as? [Any] ?? [Any]()
//        if images == nil {
//            images = [Any]()
//        }
//        return images
//    }
//
}
