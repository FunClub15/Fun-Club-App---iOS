//
//  UserLoginAdapter.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class UserLoginAdapter: ModelHelper {
    
    // let moc = DataController().managedObjectContext
    var userInfo = Array<User>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let api = API()
    let navigationHelper = NavigationHelper()
    var updateProducts = Dictionary<String, AnyObject>()
    var crtProducts = Dictionary<String, AnyObject>()
    var userID : String = "0"
    
    /**
     * Map api response on categories model and response to callback function
     */
    func mapResponseOnModel(dataFromNetworking:AnyObject, error:String, callback:(_ userInfos:User, _ message:String, _ status:String) -> Void ) {
        
        var message = error
        let user = User(context: appDelegate.moc)
        var status = "0"
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    status = "1"
                    user.id = self.getString(json: json["id"], defaultValue: "0")
//                    loadImagesFromURL(userID: user.id)
                    user.name = self.getString(json: json["fullname"], defaultValue: "NA")
                    user.username = self.getString(json: json["username"], defaultValue: "NA")

                    user.email = self.getString(json: json["email"], defaultValue: "NA")
                   
                    user.picture = self.getString(json: json["picture"], defaultValue: "")
                    user.phoneNumber = self.getString(json: json["phoneNumber"], defaultValue: "NA")
                    user.type = self.getString(json: json["type"], defaultValue: "0")
                    user.gender = self.getString(json: json["gender"], defaultValue: "NA")
                    
                    let defaults = UserDefaults.standard
                    defaults.set(user.id, forKey: "userId")
                    defaults.set(user.picture, forKey: "pic")
                    defaults.set(user.username, forKey: "userName")
                    defaults.set(user.email, forKey: "userEmail")
                    defaults.set(user.gender, forKey: "gender")
                    defaults.set(user.name, forKey: "fullName")
                    defaults.set(user.phoneNumber, forKey: "phone")
                    defaults.set(user.type, forKey: "type")
                    
                    defaults.set("true", forKey: "isLogin")
                    
                    defaults.synchronize()
                    
                    //
                }
                
                message = json["message"].rawString()!
                
            }
            
        }
        
        callback(user, message, status)
    }
    

    func loadImagesFromURL(userID: String) {
        let api = API()
        api.loadDashboardSticker(userId: userID, callback: self.dashboardStickers)
        
    }
    func dashboardStickers(_ dashboardStickersArr: Array<DashboardStickers>, _ message:String, _ status:String){
        
        if status == "1" {
            deleteAllStickers()
            for dashboardSticker in dashboardStickersArr {
                let uRl = URL(string: dashboardSticker.image)
                let request = URLRequest(url: uRl!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let _ = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() { () -> Void in
                        
                        DispatchQueue.main.async() {
                            [weak self] in
                            // Return data and update on the main thread, all UI calls should be on the main thread
                            // you could also just use self?.method() if not referring to self in method calls.
                            if let weakSelf = self {
                                
                                self?.addToCoreData(imageData: data, imageId: dashboardSticker.id)
                                
                            }
                        }
                        
                    }
                    
                    }.resume()
            }
            
            
        }
        else {
            //            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
    }

    
    func addToCoreData(imageData: Data, imageId:String){
        let context =  self.appDelegate.moc
        let dashboardImages = User(context: context)
            _ = dashboardImages.createImageData(imageData: imageData, imageId: imageId)
    }

    func deleteAllStickers() -> Void {
        // let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDashboardImages")
        
        let result = try? appDelegate.moc.fetch(fetchRequest)
        let resultData = result as! [UserDashboardImages]
        
        for object in resultData {
            print("deleted Img ID\(String(describing: object.imageId!))")
            appDelegate.moc.delete(object)
        }
        
        do {
            try appDelegate.moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }

}
