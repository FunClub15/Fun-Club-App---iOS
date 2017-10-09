//
//  UserRegisterAdapter.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class UserRegisterAdapter: ModelHelper {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // let moc = DataController().managedObjectContext
    
    /**
     * Map api response on categories model and response to callback function
     */
    func mapResponseOnModel(dataFromNetworking:AnyObject, error:String, callback:(_ message:String) -> Void ) {
        let user = User(context: appDelegate.moc)
        
        var message = error
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                
                if json["status"] == 1 {
                    user.id = self.getString(json: json["id"], defaultValue: "0")
                    
                    user.name = self.getString(json: json["fullname"], defaultValue: "0")
                    user.username = self.getString(json: json["username"], defaultValue: "0")
                    
                    user.email = self.getString(json: json["email"], defaultValue: "0")
                    
                    user.picture = self.getString(json: json["picture"], defaultValue: "0")
                    user.phoneNumber = self.getString(json: json["phoneNumber"], defaultValue: "0")
                    user.type = self.getString(json: json["type"], defaultValue: "0")
                    user.gender = self.getString(json: json["gender"], defaultValue: "gender")
                    
                    let defaults = UserDefaults.standard
                    defaults.set(user.picture, forKey: "pic")
                    defaults.set(user.username, forKey: "userName")
                    defaults.set(user.email, forKey: "userEmail")
                    defaults.set(user.gender, forKey: "gender")
                    defaults.set(user.name, forKey: "fullName")
                    defaults.set(user.phoneNumber, forKey: "phone")

                    defaults.set("true", forKey: "isLogin")
                    
                    defaults.synchronize()

                }
                message = json["message"].rawString()!
            }

        }
        
        callback(message)
    }
}
