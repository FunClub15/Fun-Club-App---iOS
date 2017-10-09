//
//  InteriorDesignAdapter.swift
//  FunClub
//
//  Created by Usman Khalil on 10/07/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class InteriorDesignAdapter: ModelHelper {
    
    // let moc = DataController().managedObjectContext
    var userInfo = Array<User>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let api = API()
    let navigationHelper = NavigationHelper()
    var userID : String = "0"
    
    /**
     * Map api response on categories model and response to callback function
     */
    func mapResponseOnModel(dataFromNetworking:AnyObject, error:String, callback:(_ interiorDesignArr: Array<InteriorDesignTatto>, _ message:String, _ status:String) -> Void ) {
        
        var message = error
        var interiorDesignArr = Array<InteriorDesignTatto>()
        var status = "0"
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    status = "1"
                    for interiorDesignTatto in json["data"].array!{
                        let tatto = InteriorDesignTatto()
                        
                        tatto.id = self.getString(json: interiorDesignTatto["id"], defaultValue: "")
                        tatto.name = self.getString(json: interiorDesignTatto["name"], defaultValue: "")
                        tatto.image = self.getString(json: interiorDesignTatto["image"], defaultValue: "")
                        tatto.category = self.getString(json: interiorDesignTatto["category"], defaultValue: "")
                        
                        interiorDesignArr.append(tatto)

                    }
//                    user.id = self.getString(json: json["id"], defaultValue: "0")
//                    
//                    user.name = self.getString(json: json["fullname"], defaultValue: "NA")
//                    user.username = self.getString(json: json["username"], defaultValue: "NA")
//                    
//                    user.email = self.getString(json: json["email"], defaultValue: "NA")
//                    
//                    user.picture = self.getString(json: json["picture"], defaultValue: "")
//                    user.phoneNumber = self.getString(json: json["phoneNumber"], defaultValue: "NA")
//                    user.type = self.getString(json: json["type"], defaultValue: "0")
//                    user.gender = self.getString(json: json["gender"], defaultValue: "NA")
//                    
//                    
//                    defaults.set("true", forKey: "isLogin")
//                    
//                    defaults.synchronize()
                    
                    //
                }
                
                message = json["message"].rawString()!
                
            }
            
        }
        
        callback(interiorDesignArr, message, status)
    }


}
