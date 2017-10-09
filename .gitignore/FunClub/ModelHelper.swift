//
//  ModelHelper.swift
//  FunClub
//
//  Created by Usman Khalil on 16/06/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import Foundation
import SwiftyJSON

class ModelHelper : NSObject {
    
    //Return expected data
    func getString( json:JSON?, defaultValue:String  ) ->String {
        var defaultValue = defaultValue
        if let value = json?.string {
            defaultValue = value
        }
        return defaultValue
    }
    
    //Return expected data
    func getDouble( json:JSON?, defaultValue:Double  ) ->Double {
        var defaultValue = defaultValue
        if let value = json?.double {
            defaultValue = value
        } else if let value = json?.string {
            defaultValue = Double(value)!
        }
        return defaultValue
    }
    
    //Return expected data
    func getInt( json:JSON?, defaultValue:Int  ) ->Int {
        var defaultValue = defaultValue
        if let value = json?.int {
            defaultValue = value
        } else if let value = json?.string {
            if let intV = Int(value) {
                defaultValue = intV
            }
        }
        return defaultValue
    }
    
    //Return expected data
    func getFloat( json:JSON?, defaultValue:Float  ) ->Float {
        var defaultValue = defaultValue
        if let value = json?.float {
            defaultValue = value
        } else if let value = json?.string {
            defaultValue = Float(value)!
        }
        return defaultValue
    }
    
    //Return expected data
    func getBoolean( json:JSON?, defaultValue:Bool  ) ->Bool {
        var defaultValue = defaultValue
        if let value = json?.bool {
            defaultValue = value
        } else if let value = json?.string    {
            defaultValue = (value == "1" || value == "True" || value == "true")
        } else if let value = json?.int {
            defaultValue = value == 1
        }
        
        return defaultValue
    }
}
