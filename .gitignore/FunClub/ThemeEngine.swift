//
//  ThemeEngine.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import Foundation
import UIKit

class ThemeEngine {
    static let sharedInstance = ThemeEngine()
    
    /**
     * Create UIColor from haxString and alpha
     * @param:
     *       colorString:String of color code, alpha:Float
     * @return:
     *   UIColor
     */
    func colorFromHexColor(colorString: String, alpha: Float) -> UIColor {
        var cString:String = colorString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.startIndex)
            // cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))//cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(alpha))
    }
    
    /**
     * Create UIColor from haxString
     * @param:
     *       colorString:String of color code
     * @return:
     *   UIColor
     */
    func colorFromHexColor(colorString: String) -> UIColor {
        return colorFromHexColor(colorString: colorString, alpha: 1.0)
    }
    
    /**
     * Create UIColor from resource
     * @param:
     *       resourceName:String
     * @return:
     *   UIColor
     */
    func colorFromResource(resourceName:String) -> UIColor {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "colors", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            if let colorString: String = (dict[resourceName] as? String) {
                return colorFromHexColor(colorString: colorString)
            }
        }
        return UIColor.gray
    }
    
    
    func getTextFieldBorderColor() -> UIColor {
        return self.colorFromHexColor(colorString: "#DCDCDC")
    }
    func getTextFieldRedBorderColor() -> UIColor {
        return UIColor.red
    }
    
    
    
    //For Menu background Color
    func setMenuRowBGColor() -> UIColor{//EEEEEE
        return self.colorFromHexColor(colorString: "#efefef")
    }
    func setMenuSelectedRowBGColor() -> UIColor{
        return self.colorFromHexColor(colorString: "#e3e3e3")
    }
    func setOverViewBGColor() -> UIColor {
        return self.colorFromHexColor(colorString: "#E1E1E1")
    }
    // Return white color for barTintColor
    func navigationBarBarTintColor() -> UIColor {
        //		return UIColor.whiteColor()
        return colorFromHexColor(colorString: "FACF0E", alpha: 1)
        
    }
    
    // Return yellow  color for tintColor
    func navigationBarTintColor() -> UIColor {
        return colorFromHexColor(colorString: "FACF0E", alpha: 1)
    }
    
    // Return gray color for default theem
    func themeColor() -> UIColor {
        return UIColor.gray
        
    }
    
    // Return gray color for product cell border
    func productCellBorderColor()-> CGColor {
        return colorFromHexColor(colorString: "c9c9c9", alpha: 1).cgColor
    }
    
    // Return black color for paging text
    func pagingTextColor() -> UIColor {
        return UIColor.black
    }
    
    // Return white color for paging selected page text
    func pagingSelectedTextColor() -> UIColor {
        return UIColor.black
    }
    // Return white color for page numbers background
    func pagingBgColor() -> UIColor {
        return UIColor.white
    }
    
    // Return orange color for selected page numbers background
    func pagingSelectedBagBgColor() -> UIColor {
        return colorFromHexColor(colorString: "FCFCFC", alpha: 1)
    }
    
    // Return gray color for paging page number border
    func pagingBorderColor() -> CGColor {
        return colorFromHexColor(colorString: "c9c9c9", alpha: 1).cgColor
    }
    
    // Return gray color for paging page number border
    func pagingSelectedBorderColor() -> CGColor {
        return colorFromHexColor(colorString: "EB9242", alpha: 1).cgColor
    }
    
    // Return green/red color for inStock label
    func inStockColor(inStock:Bool) -> UIColor {
        return ( inStock == true ) ? darkGreen1() : UIColor.red
    }
    
    func darkGreen1() ->UIColor {
        return colorFromHexColor(colorString: "#359A18")
    }
    
    // Return tick/cross string for instock
    func inStockText(inStock:Bool) -> String {
        return ( inStock == true ) ? "" : ""
    }
    
    // Return black/white color for tabs
    func productDetailsTabBtnsBgColor(active:Bool) -> UIColor {
        return ( active == true ) ? UIColor.black : UIColor.white
    }
    func productDetailsTabBtnsTxtColor(active:Bool) -> UIColor {
        return ( active == true ) ? UIColor.white : UIColor.black
    }
    
    func categorySelectedRowBg() -> UIColor {
        return UIColor.red  //colorFromHexColor("ED1C24", alpha: 1)
    }
    
    //For Disabling category/filter options
    func listingScreenBtnColor(state:Bool) -> UIColor{
        if(state){
            return colorFromHexColor(colorString: "#374046")
        }
        else{
            return UIColor.black
        }
    }
    
    //For V2 Menu SelectionView BgColor
    func setOrangeBgColor() -> UIColor{
        return colorFromHexColor(colorString: "#f78f1e")
        
    }
    
    // For TextView Placeholder color
    func setTVPlacholderColor() -> UIColor {
        return colorFromHexColor(colorString: "#C7C7CD")
    }
    
    // For Text Field background color
    func setTFBackgroundColor() -> UIColor {
        return colorFromHexColor(colorString: "#D8D8D8")
    }
    
    //Yellow
    func setYellowColor() -> UIColor {
        return colorFromHexColor(colorString: "#FACF0E")
    }
}
