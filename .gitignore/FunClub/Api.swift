//
//  Api.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration
import SwiftyJSON

class API: NSObject {
    let manager = AFHTTPSessionManager()
    override init(){//NSURLRequestReloadIgnoringLocalCacheData
        manager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData//NSURLRequest.CachePolicy.reloadIgnoringCacheData//returnCacheDataElseLoad
        manager.responseSerializer = AFHTTPResponseSerializer()
    }
    
    /**
     * Check device is reachable to internet
     * params: void
     * return: Bool
     */
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    /**
     * When internet connectivity is not found, then go to error screen
     * params:
     *   SELF: running class self
     *   SelfObj: running class self
     *   showErrorScreen: show screen or only return boolean
     * return: Bool
     */
    func checkInternet(SELF:NoInternetViewControllerDelegate, SelfObj:AnyObject, showErrorScreen:Bool) -> Bool{
        let connected = isConnectedToNetwork()
        if connected == false && showErrorScreen == true {
            UIUtility.sharedInstance.showNoInternetScreen(message: "", selDelegate:SELF, selfObj:SELF)
        }
        return connected
    }
    
    func checkError(msg :String) ->String {
        var message = msg
        if message == Constants.AFN_NO_INTERNET_MSG {
            message = Constants.ERROR_PCY_INTERNET_ATA
        } else {
            message = Constants.ERROR_SOME_THING_WENT_WRONG
        }
        
        return message
    }
    
    //MARK : SignUp User
    func signupUser(parameters:AnyObject, callback:@escaping(_ message: String) -> Void )  {
        let adapter = UserRegisterAdapter()
        
            manager.post(Constants.signupURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
                adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
            }, failure: { (operation: URLSessionDataTask?,error: Error!) in
                print("loadBanners   - Error: " + error.localizedDescription)
                adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
            
    }
    
    //MARK : SignIn User
    func signinUser(userName: String, password: String, callback:@escaping(_ userInfo:User, _ message: String, _ status:String) -> Void ) {
        
        let adapter = UserLoginAdapter()
        var parameters = Dictionary<String, AnyObject>()
        parameters["username"] = userName as AnyObject?
        parameters["password"] = password as AnyObject?
        
        //parameters["category"] = "" as AnyObject?

        manager.post(Constants.loginURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }
    
    //MARK : Facebook Login
    func facebookLogin(parameters:AnyObject, callback:@escaping(_ userInfo:User, _ message: String, _ status:String) -> Void ) {
        
        let adapter = UserLoginAdapter()
//        var parameters = Dictionary<String, AnyObject>()
//        parameters["username"] = userName as AnyObject?
//        parameters["password"] = password as AnyObject?
        
        //parameters["category"] = "" as AnyObject?
        
        manager.post(Constants.facebookRegisterURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }
    
    //MARK : Forgot password
    func forgotPassword(email: String, callback:@escaping(_ userInfo:User, _ message: String, _ status:String) -> Void ) {
        
        let adapter = UserLoginAdapter()
        var parameters = Dictionary<String, AnyObject>()
        parameters["email"] = email as AnyObject?
        
        manager.post(Constants.forgotPasswordURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
            }, failure: { (operation: URLSessionDataTask?,error: Error!) in
                print("loadBanners   - Error: " + error.localizedDescription)
                adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }

    //MARK : Forgot password
    func updateProfile(parameters:AnyObject, callback:@escaping(_ message: String) -> Void )  {
        let adapter = UserRegisterAdapter()
        
        manager.post(Constants.updateProfileURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
            }, failure: { (operation: URLSessionDataTask?,error: Error!) in
                print("loadBanners   - Error: " + error.localizedDescription)
                adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }
    
    //MARK : Interior Design
    func interiorDesign(parameters:AnyObject, callback:@escaping(_ interiorDesignArr: Array<InteriorDesignTatto>, _ message:String, _ status:String) -> Void )  {
        let adapter = InteriorDesignAdapter()
        
        manager.post(Constants.interiorDesignURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }

    //MARK : Interior Design Sticker Upload
    func interiorDesignStickerUpload(parameters:AnyObject) -> Void   {
        let adapter = DashboardStickersAdapter()
        
        manager.post(Constants.interiorDesignStickerUploadURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponse(dataFromNetworking: responseObject as AnyObject, error:"")
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponse(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription))
        })
        
    }
    
    //MARK : Uploading photo from Camera/Gallery Interior Design
    func photoUpload(parameters:AnyObject,callback:@escaping(_ message:String, _ status:String) -> Void)   {
        let adapter = DashboardStickersAdapter()
        
        manager.post(Constants.interiorDesignStickerUploadURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseUploadPhoto(dataFromNetworking: responseObject as AnyObject, error:"",callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseUploadPhoto(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }
    
    //MARK : Load Dashboard Sticker
    func loadDashboardSticker(userId:String, callback:@escaping(_ dashboardStickersArr: Array<DashboardStickers>, _ message:String, _ status:String) -> Void )  {
        let adapter = DashboardStickersAdapter()
        var parameter = Dictionary<String, AnyObject>()
        parameter["member_id"] = userId as AnyObject?

        manager.post(Constants.dashboardStickersURL, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }


    //MARK : Post Status
    func postStatus(parameters:AnyObject, callback:@escaping(_ message:String, _ status:String) -> Void )  {
        let adapter = UserWallAdapter()
        
        manager.post(Constants.postStatusURL, parameters: parameters, progress: nil, success: { (operation: URLSessionDataTask!, responseObject: Any?) in
            adapter.mapResponseOnModel(dataFromNetworking: responseObject as AnyObject, error:"", callback:callback)
        }, failure: { (operation: URLSessionDataTask?,error: Error!) in
            print("loadBanners   - Error: " + error.localizedDescription)
            adapter.mapResponseOnModel(dataFromNetworking: "" as AnyObject, error:self.checkError(msg: error.localizedDescription), callback:callback)
        })
        
    }

    
}
