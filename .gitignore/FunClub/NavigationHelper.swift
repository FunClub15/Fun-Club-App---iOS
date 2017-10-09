//
//  NavigationHelper.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import CoreData

class NavigationHelper: NSObject, UITextFieldDelegate {
    
    
    dynamic var SELF:AnyObject! //self object of the class from where we are calling it
//    var cartButton: ENMBadgedBarButtonItem?
    var className:String = ""
    var checkoutProcessStarted:Bool = false
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var tip:UILabel!
//    @IBOutlet var searchField: TextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var cartLabel: UILabel!
    
    @IBOutlet var searchIconImg: UIImageView!
    let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 80, y: 0, width: 300, height: 20))
    
    var tDotsView:UIView!
    var tipTD:UILabel!
    var tDRowBtnsAry:NSMutableArray!
    
    let loginDot: UILabel = UILabel(frame: CGRect(x: 19, y: 8, width: 15,height: 15 ))
    
    //these variable will help us in reloading navigation bar in viewWillAppear
    var wasLogingAtViewWillDisappear:Bool = false
    var isViewLoadingFirstTime:Bool = true
    var chatMessage:String = ""
    
     var replaceProductQty:Bool = false //from cart screen it should be true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fetchCartP: Array<Any> = []
    var updateProducts = Dictionary<String, AnyObject>()
    
    /**
     * Set navigation bar
     * @params:
     *  selfObj:AnyObject [self of the class from where its called]
     * @return: void
     */
    func setNavigation(selfObj:AnyObject){
        SELF = selfObj
        className = String(describing: SELF.classForCoder)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if  className == "Optional(mycart_pk.HomePageViewController)" {
            //set left navigation
            let defaults = UserDefaults.standard
            if defaults.value(forKey: "skipIntro") != nil {
                let menuButton = UIButton()
                menuButton.setImage(UIImage(named: "icon_nav_menu_black"), for: .normal)
                menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                menuButton.addTarget(SELF, action: Selector(("displaySideMenu")), for: .touchUpInside)
                SELF.navigationItem.setLeftBarButton(UIBarButtonItem(customView: menuButton), animated: true)
            }
        }
        else {
            var onBackFuncName = "goBack"
            if  className == "ThankYouScreenViewController" {
                onBackFuncName = "goToHomeScreen"
            }
            
            //set left navigation
            //let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(onBackFuncName))
            let backBtn = UIButton()
            
            backBtn.addTarget(self, action: #selector(NavigationHelper.goBack), for: .touchUpInside)
            
            //for cartview screen use back function of its own
            if  className == "CrtViewController" {
                //backBtn.target = SELF
                // backBtn.addTarget(SELF, action: Selector("goBack"), forControlEvents: .TouchUpInside)
                
            }
            backBtn.setImage(UIImage(named: "icon_back_black"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            SELF.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backBtn), animated: true)
            
            //            backBtn.setBackgroundImage(UIImage(named:"icon_back_black"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
            //            SELF.navigationItem.setLeftBarButtonItems([backBtn], animated: true)
        }
        if className == "Optional(mycart_pk.SearchViewController)" {
            let backBtn = UIButton()
            
            backBtn.addTarget(self, action: #selector(NavigationHelper.goBack), for: .touchUpInside)
            
            backBtn.setImage(UIImage(named: "icon_back_black"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            SELF.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backBtn), animated: true)
            
            searchBar.placeholder = "Search"
            searchBar.delegate = SELF as! UISearchBarDelegate?
            let leftNavBarButton = UIBarButtonItem(customView:searchBar)
            SELF.navigationItem.leftBarButtonItems?.append(leftNavBarButton)
            
            
        }
        else if className == "Optional(mycart_pk.BillingInfoViewController)" || className == "Optional(mycart_pk.ContactInfoViewController)" || className == "Optional(mycart_pk.PaymentInfoViewController)" || className == "Optional(mycart_pk.DeliveryTimeViewController)" || className == "Optional(mycart_pk.OrderReviewViewController)"{
            let backBtn = UIButton()
            
            backBtn.addTarget(self, action: #selector(NavigationHelper.goBack), for: .touchUpInside)
            
            backBtn.setImage(UIImage(named: "icon_back_black"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            SELF.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backBtn), animated: true)
            
            
            //SELF.navigationItem.leftBarButtonItems?.append(leftNavBarButton)
            
            
        }
        else if className == "Optional(mycart_pk.MyAccountViewController)"{
            //----- work for title --- start
            let mycart : UIImageView = UIImageView(image: UIImage(named: "header_logo"))
            mycart.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            mycart.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.goToHomeScreen(gestureRecognizer:)))
            mycart.addGestureRecognizer(gestureRecognizer)
            let leftItem:UIBarButtonItem = UIBarButtonItem(customView: mycart)
            SELF.navigationItem.leftBarButtonItems?.append(leftItem)
            
            
            let backBtn = UIButton()
            
            
            backBtn.setTitle("My Orders", for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
            let orderHistoryBtn = UIBarButtonItem(customView: backBtn)
            
            
            SELF.navigationItem.setRightBarButton(orderHistoryBtn, animated: true)
            
        }
        else if className == "Optional(mycart_pk.OrderHistoryViewController)"{
            //----- work for title --- start
            let mycart : UIImageView = UIImageView(image: UIImage(named: "header_logo"))
            mycart.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            mycart.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.goToHomeScreen(gestureRecognizer:)))
            mycart.addGestureRecognizer(gestureRecognizer)
            let leftItem:UIBarButtonItem = UIBarButtonItem(customView: mycart)
            SELF.navigationItem.leftBarButtonItems?.append(leftItem)
            
            
        }
            
        else
        {
            let chatBt: UIButton = UIButton()
            chatBt.setBackgroundImage(UIImage(named:"icon_chat_black"), for: UIControlState.normal)
            //            chatBt.titleLabel!.font =  UIFont(name: "fontello", size: 22)
            //            chatBt.setTitleColor(ThemeEngine.sharedInstance.navigationBarTintColor(), forState: UIControlState.normal)
            chatBt.frame = CGRect(x:0, y:0, width:25, height:26)
            chatBt.addTarget(self, action: #selector(NavigationHelper.goToChat), for: .touchUpInside)
            let chatBtn = UIBarButtonItem(customView: chatBt)
            
            //----- work for title --- start
            let mycart : UIImageView = UIImageView(image: UIImage(named: "header_logo"))
            mycart.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            mycart.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.goToHomeScreen(gestureRecognizer:)))
            mycart.addGestureRecognizer(gestureRecognizer)
            let leftItem:UIBarButtonItem = UIBarButtonItem(customView: mycart)
            SELF.navigationItem.leftBarButtonItems?.append(leftItem)
            
            let btnSearch: UIButton = UIButton()
            btnSearch.setBackgroundImage(UIImage(named:"icon_search_black"), for: UIControlState.normal)
            
            btnSearch.frame = CGRect(x: 0, y: 0, width: 25, height: 26)
            //        btnSearch.setImage(UIImage(named: "dealm.jpg"), forState: .Normal)
            let searchButton = UIBarButtonItem(customView: btnSearch)
            
            let defaults = UserDefaults.standard
            var pCount = 0
            //            defaults.set(product.totalQty, forKey: "tQty")
            if defaults.value(forKey: "tQty") != nil {
                pCount = defaults.value(forKey: "tQty")! as! Int
            }          //cart button with cart item count
            let cartBt = UIButton()
            cartBt.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 26)
            cartBt.setTitle("", for: .normal)//"\(appDelegate.totalQty)"
            
            cartBt.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 13)
            cartBt.setBackgroundImage(UIImage(named:"icon_cart_black"), for: UIControlState.normal)
            
                      //icon_cart_black
            let spaceBt: UIButton = UIButton()
            spaceBt.setTitleColor(ThemeEngine.sharedInstance.navigationBarTintColor(), for: .normal)
            spaceBt.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            // UI Button for space
            let maxSpaceBt: UIButton = UIButton()
            maxSpaceBt.setTitleColor(ThemeEngine.sharedInstance.navigationBarTintColor(), for: .normal)
            maxSpaceBt.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            let maxSpaceUIBt = UIBarButtonItem(customView: maxSpaceBt)
            
            
            
            
            let negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSpace.width = -12.0
            
            
            
            
            
            //SELF.navigationItem.setRightBarButtonItem(searchButton, animated: true)
//            SELF.navigationItem.setRightBarButtonItems([negativeSpace, cartButton!, searchButton, chatBtn, maxSpaceUIBt], animated: true)
            
            
        }
        //----- work for title --- end
        
        
        //icon_search_black
        
    }
    
    /**
     * Perform actions in viewWillAppear
     */
    func actionsInViewWillAppear(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //if login status has been changed then reloaded navigation
        //        if self.isViewLoadingFirstTime == false && self.wasLogingAtViewWillDisappear != appDelegate.user.isLogin() {
        //                self.setNavigation(selfObj: SELF)
        //        }
        let defaults = UserDefaults.standard
        
        //update cart counter
        //        var pCount = 0
        if defaults.value(forKey: "tQty") != nil {
            
            
        }
        // loginDot.textColor = appDelegate.user.isLogin() ? UIColor.greenColor() : UIColor.redColor()
        
        //set navigation bar to normal if we are comming from chatViewController [ red nav bar ]
        //  let nc = NSNotificationCenter.defaultCenter()
        // nc.postNotificationName(ZDC_CHAT_UI_WILL_UNLOAD, object: nil)
        
        self.isViewLoadingFirstTime = false
        
    }
    
    /**
     * Go to chat screen [ if we are already on it, do nothing ]
     * @params: void
     * @return: void
     */
    func goToChat(){
        
        //        ZDCChat.instance().session.trackEvent("Chat button pressed: (no pre-chat form)")
        //        ZDCChat.start(nil)
        //        if chatMessage != "" {
        //            ZDCChat.instance().session.addObserver(self, forConnectionEvents:#selector(NavigationHelper.chatStarted))
        //        }
        //  ZDCChat.addObserver(NavigationHelper.chatStarted)
        //ZDCChat.addObserver(self, forConnectionEvents:#selector(NavigationHelper.chatStarted))
        // ZDCChat.instance().session.addObserver(self, forConnectionEvents:#selector(NavigationHelper.chatStarted))
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = ThemeEngine.sharedInstance.navigationBarBarTintColor()//UIColor(red: 0.91, green: 0.16, blue: 0.16, alpha: 1.0)
        
    }
    
    // When chat started then send chat message, remove observer, clear message
    func chatStarted(){
        //        if ZDCChat.instance().session.connectionStatus() == ZDCConnectionStatus.Connected {
        //            ZDCChat.instance().session.sendChatMessage(self.chatMessage)
        //            ZDCChat.instance().session.removeObserverForConnectionEvents(self)
        //            self.chatMessage = ""
        //        }
        
            }
    
    
    /*
     * This method detects tap
     * and shows home screen
     * @params:
     *      gestureRecognizer: UIGestureRecognizer
     * return:
     *      void
     */
    func goToHomeScreen(gestureRecognizer: UIGestureRecognizer) {
        goToHomeScreen()
    }
    
    func goToHomeScreen() {
        SELF.navigationController!!.popToRootViewController(animated: true)
    }
    
    /*
     * This method is called when the height
     * of status bar changes.
     */
    func statusBarFrameChanged(notification: NSNotification) {
        if searchView != nil{
            self.showSearchField(show: false)
            self.showSearchField(show: true)
        }
    }
    
    
    // show/hide search field
    func showSearchField(show:Bool){
        if show {
            // self.showSearchBarView()
        } else if searchView != nil {
            searchView.removeFromSuperview()
            //            tip.removeFromSuperview()
            //            tip = nil
            searchView = nil
        }
    }
    func showAlert(show:Bool, pName:String){
        if show {
            self.showSearchBarView(productName: pName)
        } else if searchView != nil {
            searchView.removeFromSuperview()
            // tip.removeFromSuperview()
            //  tip = nil
            searchView = nil
        }
        else if searchView == nil {
            self.showSearchBarView(productName: pName)
            
            searchView.alpha = 0
        }
    }
    
    /*
     * To show search bar on screen
     */
    func showSearchBarView(productName: String){
        let currentWindow = UIApplication.shared.keyWindow
        let height:CGFloat = 40.0 //height
        let insidesHeight:CGFloat = 40.0 //height
        let searchBtnWidth:CGFloat = 60.0
        
        //        NotificationCenter.default.addObserver(self, selector: "statusBarFrameChanged:", name: NSNotification.Name(rawValue: "Change"), object: UIApplication.shared.delegate)
        
        var currentStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        if(currentStatusBarHeight > 20){
            currentStatusBarHeight = 20
        } else {
            currentStatusBarHeight = 0
        }
        
        
        let pad:CGFloat = 0.0 //padding
        let border:CGFloat = 1.0 //border width
        let searchViewY = 60//SELF.navigationController!!.navigationBar.frame.origin.y + SELF.navigationController!!.navigationBar.frame.size.height + currentStatusBarHeight
        
        
        searchView = UIView(frame: CGRect(x: 0, y: searchViewY, width:440 , height: Int(height)))//SELF.view!.frame.width
        searchView.backgroundColor = UIColor.black//ThemeEngine.sharedInstance.colorFromHexColor(colorString: "#EEEEEE")
        
        
        cartLabel = UILabel()
        cartLabel.frame = CGRect(x: 10 ,y: pad ,width: (searchView.frame.width-searchBtnWidth-pad*2-border*2) , height: insidesHeight)
        cartLabel.text = "\(productName) added to cart successfully"
        cartLabel.font = UIFont(name: "OpenSans", size: 12)!
        cartLabel.textColor = UIColor.white
        cartLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cartLabel.numberOfLines = 3
        searchView.addSubview(cartLabel)
        currentWindow?.addSubview(searchView)
        
    }
    
    //MARK: Three dot in navigation bar tap
    func onThreeDotsTap(){
        self.showThreeDots( show: tDotsView == nil )
    }
    
    //show/hide search field
    func showThreeDots(show:Bool){
        if show {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var rowTitles = ["List", "Grid"]
            //            if appDelegate.user.isLogin() {
            //                rowTitles = [Constants.MyAccount, Constants.Logout]
            //            }
            
            let currentWindow = UIApplication.shared.keyWindow
            let tDotsRowH:CGFloat = 40.0 //height
            let tDotsRowW:CGFloat = SELF.navigationController!!.navigationBar.frame.size.width/4
            
            let tDotsViewPadR:CGFloat = 10.0
            let tDotsViewX:CGFloat = currentWindow!.frame.size.width - tDotsRowW - tDotsViewPadR
            let dostsViewY:CGFloat = SELF.navigationController!!.navigationBar.frame.origin.y + SELF.navigationController!!.navigationBar.frame.size.height
            
            
            //work for tip and tip frame
            let tipTDW:CGFloat = 30.0
            let tipTDX:CGFloat = ( currentWindow!.frame.size.width - tipTDW - tDotsViewPadR  )
            let tipTDFrame:CGRect = CGRect(x: tipTDX, y: dostsViewY - 12, width: tipTDW, height: 20)
            
            tipTD = UILabel(frame: tipTDFrame)
            tipTD.textColor  = ThemeEngine.sharedInstance.colorFromHexColor(colorString: "#EEEEEE")
            tipTD.font = UIFont(name: "fontello", size: 50)!
            tipTD.text = ""
            
            tDotsView = UIView(frame: CGRect(x: tDotsViewX, y: dostsViewY, width: tDotsRowW, height: (tDotsRowH * CGFloat(rowTitles.count) ) ) )
            tDotsView.backgroundColor = ThemeEngine.sharedInstance.colorFromHexColor(colorString: "#EEEEEE")
            
            
            currentWindow?.addSubview(tipTD)
            currentWindow?.addSubview(tDotsView)
            
            tDRowBtnsAry = NSMutableArray()
            for i in (0 ..< rowTitles.count){
                let tDRowBtn:UIButton = UIButton(frame: CGRect(x: tDotsViewX, y: (dostsViewY + (tDotsRowH*CGFloat(i))), width: tDotsRowW, height: tDotsRowH))
                tDRowBtn.backgroundColor = ThemeEngine.sharedInstance.colorFromHexColor(colorString: "#EEEEEE")
                tDRowBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tDRowBtn.setTitle(rowTitles[i], for: .normal)
                tDRowBtn.titleLabel!.font = UIFont(name: "OpenSans", size: 12)!
                tDRowBtn.addTarget(self, action: Selector(("threeDotsOnTouchDown:")), for: UIControlEvents.touchDown)
                tDRowBtn.addTarget(self, action: Selector(("threeDotsOnTouchUpInside:")), for: UIControlEvents.touchUpInside)
                tDRowBtn.tag = i
                
                currentWindow?.addSubview(tDRowBtn)
                tDRowBtnsAry.add(tDRowBtn)
            }
            
        }
        else if tDotsView != nil {
            tDotsView.removeFromSuperview()
            tipTD.removeFromSuperview()
            
            tDotsView = nil
            tipTD = nil
            
            for i in (0..<tDRowBtnsAry.count-1).reversed(){
                
                //            for(var i=(tDRowBtnsAry.count-1); i>=0; i -= 1){
                (tDRowBtnsAry[i] as AnyObject).removeFromSuperview()
            }
            tDRowBtnsAry = nil
            
        }
    }
    
    // Three dot in navigation bar tap down
    func threeDotsOnTouchDown(sender: AnyObject){
        let rowBtn:UIButton = sender as! UIButton
        rowBtn.backgroundColor = UIColor.red
        rowBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    //
    //    //Three dot in navigation bar tap down and perform actions
    func threeDotsOnTouchUpInside(sender: AnyObject){
        let rowBtn:UIButton = sender as! UIButton
        rowBtn.backgroundColor = ThemeEngine.sharedInstance.colorFromHexColor(colorString: "#EEEEEE")
        rowBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        if appDelegate.user.isLogin() {
        //            if rowBtn.titleLabel?.text == Constants.MyAccount {
        //                self.goToMyOrder()
        //            } else if rowBtn.titleLabel?.text == Constants.Logout {
        //                self.logout()
        //            }
        //        } else {
        //            if rowBtn.titleLabel?.text == Constants.Login {
        //                self.goToMyOrder() //user will go to login screen if he is not loggedin
        //            } else if rowBtn.titleLabel?.text == Constants.Register {
        //                self.goToRegister()
        //            }
        //        }
        
        self.showThreeDots(show: false)
    }
    
    //Hide extra views when going from screen
    func viewWillDisappear(animated: Bool) {
        self.showSearchField(show: false)
        //self.showThreeDots(false)
        
        // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //self.wasLogingAtViewWillDisappear = appDelegate.user.isLogin()
    }
    
    
    
  
  
    //MARK: Go To
    /**
     * Simply go back just popViewControllerAnimated(true)
     * @params: void
     * @return: void
     */
    @IBAction func goBack() {
        SELF.navigationController!!.popViewController(animated: true)
    }
    
   
    
    /**
     * removeController from navigation stack
     * @params:
     *   removeClass: className you want to remove
     */
    func removeFromNavigationStack(removeClass:String){
        var viewControllers:Array<UIViewController> =  (SELF.navigationController?!.viewControllers)!
        for i in (0..<viewControllers.count-1).reversed(){
            // for ( var i=(viewControllers.count-1); i>0; i--){
            if (  viewControllers[i].nibName == removeClass )  {
                viewControllers.remove(at: i)
            }
        }
        SELF.navigationController!!.viewControllers = viewControllers
    }
    
    //remove controller from navigation stack,
    func removeLastFromNavStack(lastControllerNumber:Int){
        var countFromLast = 0
        var viewControllers:Array<UIViewController> =  (SELF.navigationController?!.viewControllers)!
        for i in (0..<viewControllers.count-1).reversed(){
            
            //        for ( var i=(viewControllers.count-1); i>0; i--){
            countFromLast += 1
            if (  lastControllerNumber == countFromLast )  {
                viewControllers.remove(at: i)
                break
            }
        }
        SELF.navigationController!!.viewControllers = viewControllers
    }
    
    // Go to cart screen, screen is in navigation stack
    func goToPrevCartScreen(){
        var viewControllers:Array<UIViewController> =  (SELF.navigationController?!.viewControllers)!
        for i in (0..<viewControllers.count-1).reversed(){
            //for ( var i=(viewControllers.count-1); i>0; i--){
            let classForCoder = String(describing: viewControllers[i].classForCoder)
            if ( classForCoder != "CrtViewController" )  {
                viewControllers.remove(at: i)
            } else {
                break
            }
        }
        SELF.navigationController!!.viewControllers = viewControllers
    }
    
    //Go to MyAccount screen after login and remove all navigation stack before it till home screen
    //    func goToScreenAfterLogin(){
    //        if self.goToMyOrder() {
    //            self.saveLoginUserInfoInDb()
    //            self.deleteControllerBwLastAndFirst()
    //        }
    //    }
    
    //    func saveLoginUserInfoInDb(){
    //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        let jsonString:String = DatabaseHelper.sharedInstance.createJsonFromModel( appDelegate.user )
    //        DatabaseHelper.sharedInstance.setValueInUserDefaults(Constants.USERINFO, value: jsonString)
    //    }
    //
    //    //Go to screen after logout
    //    func gotToScreenAfterLogout(){
    //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        DatabaseHelper.sharedInstance.setValueInUserDefaults(Constants.USERINFO, value:"")
    //        //remove user info from application model
    //        appDelegate.user = User()
    //
    //        className = String(SELF.classForCoder)
    //        if  className == "HomeViewController" {
    //            self.setNavigation(SELF)
    //            self.actionsInViewWillAppear()
    //        } else{
    //            //go to main screen
    //            SELF.navigationController!!.popToRootViewControllerAnimated(true)
    //        }
    //    }
    
    //this function will help you in deleting all controllers between last and first controller
    func deleteControllerBwLastAndFirst(){
        var viewControllers:Array<UIViewController> =  (SELF.navigationController?!.viewControllers)!
        let count = viewControllers.count
        for i in (0..<count-1).reversed(){
            
            // for ( var i=(count-1); i>0; i--){
            if (  i != (count-1)  )  {
                viewControllers.remove(at: i)
            }
        }
        SELF.navigationController!!.viewControllers = viewControllers
    }
    
    
      //
    //    //MARK: Logout from app
    //    func logout(){
    //        self.logoutFromFb()
    //        
    //        // Track user profile
    //        EventTracker.sharedInstance.userProfiler()
    //        
    //        self.gotToScreenAfterLogout()
    //    }
    //    
    //    //logout from facebook
    //    func logoutFromFb(){
    //        if((FBSDKAccessToken.currentAccessToken()) != nil){
    //            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    //            loginManager.logOut()
    //        }
    //    }
    
}
