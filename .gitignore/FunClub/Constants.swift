//
//  Helper.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import Foundation

class Constants {
    //https://www.mycart.pk/appservice/
    static let sharedInstance = UIUtility()//"http://www.mycart.com.pk/demo/appservice/
    
    static let loginURL = "http://dev.technology-minds.com/funclub/manage/webservices/member_login.php"
    static let signupURL = "http://dev.technology-minds.com/funclub/manage/webservices/ios_member_register.php"//"http://dev.technology-minds.com/funclub/manage/webservices/member_register.php"
    static let forgotPasswordURL = "http://dev.technology-minds.com/funclub/manage/webservices/forgot_password.php"
    static let updateProfileURL = "http://dev.technology-minds.com/funclub/manage/webservices/ios_update_profile.php"//"http://dev.technology-minds.com/funclub/manage/webservices/update_profile.php"
    static let interiorDesignURL = "http://dev.technology-minds.com/funclub/manage/webservices/interior_design.php" 
    static let facebookLoginURL = "http://www.technology-minds.com/dev/funclub/manage/webservices/facebook_login.php"
    static let facebookRegisterURL = "http://www.technology-minds.com/dev/funclub/manage/webservices/facebook_register.php"
    static let interiorDesignStickerUploadURL = "http://dev.technology-minds.com/funclub/manage/webservices/dashboard_insert.php"
    static let dashboardStickersURL = "http://dev.technology-minds.com/funclub/manage/webservices/dashboard_images.php"
    static let postStatusURL = "http://dev.technology-minds.com/funclub/manage/webservices/wall/wall_post_insert.php"
    
    
    
    static let Customer_Registered_Success = "Customer registered successfully"
    static let Account_Not_Confirmed = "This account is not confirmed."
    static let True = "true"
    
    
    
    static let LoginWthFB = "Login with FB"
    static let ShareOnFB = "Share on FB"

    static let LoginWthGoogle = "Login with Google+"
    static let ShareOnGooglePlus = "Share on Google+"

    
    static let Registered_Success = "You are registered successfully.Please verify your email on your id to enjoy FunClub."

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
      
    
    static let LOADING_MSG = "Loading"
    static let THIS_PAGE_COUNT = "THIS_PAGE_COUNT"
    static let PAGING_START_PAGE = 1
    
    static let failure = "failure"
    static let REQ_SUCCESS = "success"
    static let REQ_FAILED = "Request failed"
    static let REQ_FAILD_MSG1 = "Something went wrong!"
    static let FILTER_BY_CAT = "cat"
    static let PRODUCT_FIRST_PAGE = 1
    static let PRODUCT_LISTING_LIMIT = 10
    static let AFN_REQ_FAILED =  "Request failed: not found (404)"
    static let AFN_NO_INTERNET_MSG =  "The Internet connection appears to be offline."
    static let ERROR_SOME_THING_WENT_WRONG = "Something went wrong, please try again"
    static let ERROR_PCY_INTERNET_ATA =    "Please check your internet connectivity and try again."
    static let Alert = "Alert"
    static let PD_CA_MSG_SHOW = "Place call on Yayvo Help Line"
    static let PD_CA_MSG = "+9221111192986"
    static let PD_CA_CALL = "Call"
    static let Cancel = "Cancel"
    static let orderStatusCancelled = "Canceled"
    static let orderStatusPendingRefunds = "Pending Funds"
    static let orderStatusPaid = "Paid"
    static let orderStatusComplete = "Complete"
    static let orderStatusCashOnDelivery = "Cash On Delivery"
    
    static let PRODUCT_TYPE_CONFIGURABLE = "configurable"
    static let PRODUCT_TYPE_SIMPLE = "simple"
    
    // when user not select any option from product avilable options
    static let OK = "Ok"
    static let CLOSE = "Close"
    static let PD_SOA_MSG = "Please select from product options"
    static let PD_S_TITLE = "Yayvo is awesome! Check out this website about it!"
    
    // Deal types
    static let cms_page = "cms_page"
    static let product = "product"
    static let category = "category"
    static let CAMPAIGN_PAGE = "campaign_page"
    
    static let requesterType = "iphone_app"
    // user types
    static let USER_ANONYMOUS = "anonymous"
    static let USER_YAYVO = "yayvo"
    static let USER_FACEBOOK = "facebook"
    
    static let Connect_With_Facebook = "Connect With Facebook"
    static let Logout_From_Facebook = "Logout"
    
    static let DEF_CONTRY_CODE = "PK"
    static let Please_enter_name = "Please enter name"
    static let Please_enter_first_name = "Please enter first name"
    static let Please_enter_last_name = "Please enter last name"
    static let Please_enter_address = "Please enter address"
    static let Please_select_city = "Please select city"
    static let Please_enter_city  = "Please enter city name"
    static let Please_enter_mobile_number = "Please enter mobile number"
    static let Please_enter_valid_mobile_number = "Please enter valid mobile number"
    static let Please_enter_country_name = "Please enter county name"
    
    static let Please_enter_user_name = "Please enter username"

    static let Please_enter_email_address = "Please enter email address"
    static let Please_enter_valid_email_address = "Please enter valid email address"
    static let Please_enter_password = "Please enter password"
    static let Please_enter_confirm_password = "Please enter confirm password"
    static let Password_are_not_matching = "Password are not matching"
    static let The_password_must_have_at_least_6_characters = "The password must have at least 6 characters"
    static let fullNameMessage = "Full Name must consist of at least two words"
    
    // Headings
    static let HEADING_EDIT_SHIPPING_ADDRESS = "EDIT SHIPPING ADDRESS"
    static let HEADING_EDIT_BILLING_ADDRESS = "EDIT BILLING ADDRESS"
    static let HEADING_ADD_SHIPPING_ADDRESS = "ADD SHIPPING ADDRESS"
    static let HEADING_ADD_BILLING_ADDRESS = "ADD BILLING ADDRESS"
    
    static let CountryName = "Pakistan"
    static let PlaceHolderAddress = "Address"
    
    // Crittercism
    static let CRITTER_APP_ID = "568fdcd9cb99e10e00c7ec5f"
    static let CRITTER_API_KEY = "XQ9yxQC078mXbDDEJUikKYN68DGttp2f"
    
    
    // Category/Filters not available
    static let sortMessage = "Sorting is not available"
    static let categoryMessage = "Subcategories are not available"
    static let filterMessage = "Filters are not available"
    
    // Instock/Out of stock
    static let IN_STOCK = "Instock"
    static let OUT_OF_STOCK = "Out of stock"
    
    static let UPDATE_APP_MSG = "Please update to the newer version of the app"
    static let Update = "Update"
    
    static let USERINFO = "USERINFO"
    static let CARTITEMS = "CARTITEMS"
    static let EMAIL_SUBSCRIPTION = "EMAIL_SUBSCRIPTION"
    static let DONE = "DONE"
    
    static let Please_enter_discount_code = "Please enter discount code"
    
    // Purchase Limit exceeds
    static let LIMIT_EXCEEDS = "“Sorry, you cannot place an order greater than PKR 100,000 through the mobile app. In order to place this order, please log on to www.yayvo.com”"
    
    // Confirmation For Delete Product FRom Cart
    static let DELETE_PRODUCT = "Are you sure you want to delete"
    static let CONFIRM_ALERT = "Confirmation"
    static let YES = "Yes"
    static let NO = "No"
    
    static let SEARCH_FIELD_PLACEHOLDER_TEXT = "Hello... What are you looking for today?"
    
    static let Login = "Login"
    static let Register = "Register"
    static let MyAccount = "My Account"
    static let Logout = "Logout"
    
    static let HASH_URL = "#"
    static let Cash_On_Deliver = "Cash On Deliver"
    
    static let DISCOUNT_SUCCESS_TITLE = "Discount Code Applied"
    static let DISCOUNT_SUCCESS_MESSAGE = "Your Discount Coupon has been applied successfully"
    
    static let EvTypePurchase = "Purchase"
    static let EvTypeAbandonCart = "Abandon Cart"
    static let EvTypeGPS = "GPS"
    
    
    static let DELETE_ADDRESS = "Are you sure you want to delete"
    static let No_History = "You don't have any order history"
    static let No_Reslt = "Your search returns no results."
    
    
    // Menu left side childs spacing from right side
    static let callMeNow = "Call Me Now!"
    static let level0 : CGFloat = 43
    static let level1 : CGFloat = 53
    static let level2 : CGFloat = 63
    
    static let CAMPAIGN_BANNERS_URL = "https://api.yayvo.com/campaign_banner"
    static let CAMPAIGN_BANNERS_PRO_URL = "https://api.yayvo.com/campaign_products"
    
    
    static let UPDATE_USER_INFO = "https://api.yayvo.com/update-user-info"
    static let UPDATE_PASSWORD = "https://api.yayvo.com/change-password"
    static let UPDATE_USER_CREDITS = "https://api.yayvo.com/user/recharge"
    static let ORDER_DETAILS = "https://api.yayvo.com/orderDetail"
    
    static let CreditAlert = "Please enter recharge code"
    
    //Iphone 4 height
    static let IPHONE4_HEIGHT : CGFloat = 480
    static let SELECT_PAYMENT_METHOD = "Please select payment method"
    
    
    
    
}
