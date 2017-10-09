//
//  Loading.swift
//  FunClub
//
//  Created by Usman Khalil on 16/06/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Loading {
    static let sharedInstance = Loading()
    
    /**
     * return black overlayview for loading
     */
    func createOverlayForLoader(frame:CGRect) -> UIView {
        let overlay = UIView(frame: frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.6
        
        return overlay
    }
    
    /**
     * show loader and overlay
     */
    func showLoader(show:Bool, view:UIView, overlay:UIView ){
        if show {
            //            let overlay = self.createOverlayForLoader(view.frame)
            view.addSubview(overlay)
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            //            loadingNotification.bezelView .backgroundColor = UIColor.clear
            //            loadingNotification.bezelView contentColor = UIColor.red
            loadingNotification.label.text = Constants.LOADING_MSG
            
        } else {
            overlay.removeFromSuperview()
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    
    /**
     *  Disable tap on view and navigation buttons
     */
    func disableLinks(nc:UINavigationController,enable:Bool){
        nc.navigationBar.isUserInteractionEnabled = enable
        nc.view.isUserInteractionEnabled = enable
    }
    
}
