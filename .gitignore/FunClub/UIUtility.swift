//
//  UIUtility.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import Foundation
import UIKit

class UIUtility {
    static let sharedInstance = UIUtility()
    /**
     * Get Ratio
     * @param:
     *       oldWidth:CGFloat, oldHeight:CGFloat, newWidth:CGFloat
     * @return:
     *   new ratio height
     */
    func getRatioHeight( oldWidth:CGFloat, oldHeight:CGFloat, newWidth:CGFloat ) ->CGFloat{
        let newHeight = (oldHeight/oldWidth)*newWidth
        return newHeight
    }
    
    /**
     * Show iOS default alert
     * @params: title:String, message:String, btnTitle:String
     * @return: void
     */
    func showAlert(title:String, message:String, btnTitle:String){
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: btnTitle)
        alert.show()
    }
    
    /**
     * Start activity indicator / Stop and remove from view
     */
    func startRemoveActivityIndicator(start:Bool, aIndicator:UIActivityIndicatorView){
        if start {
            aIndicator.startAnimating()
        } else {
            aIndicator.stopAnimating()
            aIndicator.removeFromSuperview()
        }
    }
    
    /**
     * Check email address is valid
     * @param: emailAdd string
     *  @return: Bool
     */
    func isValidEmail(emailAdd:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAdd)
    }
    //  /*
    /***
     * Remove tab(\t) newline (\n) and spaces from string and return
     */
    func removeNewLineTabAndSpaces(myString:String) -> String {
        let trimmedString = myString.trimmingCharacters(in: .whitespacesAndNewlines)//myString.stringByTrimmingCharactersInSet(
        //            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        //        )
        return trimmedString
    }
    
    /***
     * When unable to load API or found any error from api side then show error screen
     */
    func showNoInternetScreen(message:String, selDelegate:NoInternetViewControllerDelegate, selfObj:AnyObject){
        let vc = NoInternetViewController(nibName: "NoInternetViewController", bundle: nil)
        vc.delegate = selDelegate
        vc.msg = message
        let navigationController: UINavigationController = UINavigationController(rootViewController: vc)
        selfObj.present(navigationController, animated: true, completion: nil)
        //        selfObj.present(navigationController, animated: true, completion: nil)
    }
    
//    /**
//     * This function will return product price string with comma. Eg. 75,000
//     */
//    func getPriceWithComma( pPrice:Double) -> String {
//        var priceString = ""
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal//NumberFormatter.Style.DecimalStyle
//        priceString = numberFormatter.string(from: pPrice as NSNumber)!//numberFormatter.stringFromNumber(NSNumber(pPrice))//(NSNumber(pPrice))!
//        return priceString
//    }
    
//    /**
//     * Get configurable product price with user selected options
//     */
//    func getProductPriceWithSelectedOptions( product:Product) -> Double {
//        var pPrice = product.price
//        
//        for availableIn in product.availableIn {
//            for aiOption in availableIn.options {
//                if aiOption.selected  {
//                    pPrice += aiOption.pricing_value
//                }
//            }
//        }
//        
//        return pPrice
//    }
//    
    
}
