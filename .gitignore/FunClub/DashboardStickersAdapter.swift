//
//  DashboardStickersAdapter.swift
//  FunClub
//
//  Created by Usman Khalil on 22/07/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class DashboardStickersAdapter: ModelHelper {
    
    // let moc = DataController().managedObjectContext
    var userInfo = Array<User>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let api = API()
    let navigationHelper = NavigationHelper()
    var userID : String = "0"
    
    /**
     * Map api response on categories model and response to callback function
     */
    func mapResponseOnModel(dataFromNetworking:AnyObject, error:String, callback:(_ dashboardStickersArr: Array<DashboardStickers>, _ message:String, _ status:String) -> Void ) {
        
        var message = error
        var dashboardStickersArr = Array<DashboardStickers>()
        var status = "0"
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    status = "1"
                    deleteAllStickers()
                    for interiorDesignTatto in json["data"].array!{
                        let tatto = DashboardStickers()
                        
                        tatto.id = self.getString(json: interiorDesignTatto["id"], defaultValue: "")
                        tatto.member_id = self.getString(json: interiorDesignTatto["member_id"], defaultValue: "")
                        tatto.image = self.getString(json: interiorDesignTatto["image"], defaultValue: "")
                        
                        dashboardStickersArr.append(tatto)
                        
                    }
                }
                else {
                    status = "2"
                }
                
                message = json["message"].rawString()!
                
            }
            
        }
        
        callback(dashboardStickersArr, message, status)
    }
    
    
    func mapResponse(dataFromNetworking:AnyObject, error:String) -> Void  {
        
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    let imageUrl = self.getString(json: json["image"], defaultValue: "")
                    let imageId = self.getInt(json: json["id"], defaultValue: 0)
                    
                    let defaults = UserDefaults.standard
                    //
                    
                    let base = defaults.value(forKey: "Base64")
                    let base64 = NSData(base64Encoded: base as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)



                    let context =  self.appDelegate.moc
                    let dashboardImages = User(context: context)
                    _ = dashboardImages.createImageData(imageData: base64! as Data, imageId: String(imageId))
                   
                /*
                    let uRl = URL(string: imageUrl)
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
                                    if self != nil {
                                        
                                        let context =  self?.appDelegate.moc
                                        let dashboardImages = User(context: context!)
                                        _ = dashboardImages.createImageData(imageData: base as! Data, imageId: String(imageId))
                                    }
                                }
                                
                            }
                            
                            }.resume()
                    */
                }
                
                
            }
            
        }

    }
    
    func mapResponseUploadPhoto(dataFromNetworking:AnyObject, error:String, callback:(_ message:String, _ status:String) -> Void)  {
        
        var message = error
        var status = "0"
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    let imageUrl = self.getString(json: json["image"], defaultValue: "")
                    let imageId = self.getInt(json: json["id"], defaultValue: 0)
                    status = "1"
                    let defaults = UserDefaults.standard
                    //
                    
                    let base = defaults.value(forKey: "Base64")
                    let base64 = NSData(base64Encoded: base as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                    
                    
                    
                    let context =  self.appDelegate.moc
                    let dashboardImages = User(context: context)
                    _ = dashboardImages.createImageData(imageData: base64! as Data, imageId: String(imageId))
                    
        
                }
                
                
            }
            
        }
        callback(message, status)

    }
    
    func deleteAllStickers() -> Void {
        // let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDashboardImages")
        
        let result = try? appDelegate.moc.fetch(fetchRequest)
        let resultData = result as! [UserDashboardImages]
        
        for object in resultData {
            print("deleted Img ID\(String(describing: object.imageId!))")
            appDelegate.moc.delete(object)
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
