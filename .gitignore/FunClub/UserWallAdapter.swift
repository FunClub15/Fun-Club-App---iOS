//
//  UserWallAdapter.swift
//  FunClub
//
//  Created by NISUM on 9/19/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class UserWallAdapter: ModelHelper {
    
    // let moc = DataController().managedObjectContext
    var userInfo = Array<User>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /**
     * Map api response on categories model and response to callback function
     */
    func mapResponseOnModel(dataFromNetworking:AnyObject, error:String, callback:(_ message:String, _ status:String) -> Void ) {
        
        var message = error
        var userWallArr = Array<UserWall>()
        var userWall = UserWall()
        var status = "0"
        
        if error == "" {
            
            let json = JSON(data: dataFromNetworking as! Data)
            if json != JSON.null {
                if json["status"] == 1 {
                    status = "1"
                    
                        userWall.picture = self.getString(json: json["picture"], defaultValue: "")
                        userWall.post_description = self.getString(json: json["post_description"], defaultValue: "")
                        userWall.video = self.getString(json: json["video"], defaultValue: "")
                        
                        
                    
                }
                else {
                    status = "2"
                }
                
                message = json["message"].rawString()!
                
            }
            
        }
        
        callback(message, status)
    }
}
