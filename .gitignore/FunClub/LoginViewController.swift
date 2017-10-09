//
//  LoginViewController.swift
//  FunClub
//
//  Created by Usman Khalil on 16/06/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Social
import GoogleSignIn
import SafariServices
import CoreData


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate ,GIDSignInDelegate,GIDSignInUIDelegate  {
 
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var tempLastOpenTF: UITextField! //input field object which in edit mode

    
    var overlay : UIView? //loading overlay

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userID: String = "0"
    
    var dashBoardStickersDataArr : [Data] = []
    var dashBoardStickersIdArr : [String] = []
    
    var dashboardImages : [UserDashboardImages] = []
    
    var imgCount : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overlay = Loading.sharedInstance.createOverlayForLoader(frame: CGRect(x:0,y:0, width:600, height:800))

        let defaults = UserDefaults.standard
        

        if defaults.value(forKey: "isLogin") != nil {
            let abc = defaults.value(forKey: "isLogin") as! String
            
            if abc == "Y" {
                delLoadStickers()
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealNavigationViewController") as! UINavigationController
//                appDelegate.window?.rootViewController = newViewController
//                appDelegate.window?.makeKeyAndVisible()
//                self.show(newViewController, sender: self)

            }
        }
        

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        forgotPasswordView.isHidden = true
        
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        toggleAuthUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
        
    }
    
    func showLoader(show:Bool){
        Loading.sharedInstance.showLoader(show: show, view:self.view, overlay:self.overlay! )
        // Loading.sharedInstance.disableLinks( nc: self.navigationController!, enable:(!show) )
    }
    
    
    //MARK: KeyBoard Delegate Functoins
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        nextOnTextFields(textField)
        
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tempLastOpenTF = textField
        //         Create a button bar for the Keyboard
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        //         Setup the buttons to be put in the system.
        let closeBtn = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.endEditingNow) )
        
        let toolbarButtons = [closeBtn]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = inputToolbar
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tempLastOpenTF = textField
    }
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.endEditingNow))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        var nextButton  = UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.nextField))
        nextButton.width = 50.0
        var previousButton  = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoginViewController.previousField))
        
        toolbar.setItems([fixedSpaceButton, previousButton, fixedSpaceButton, nextButton, flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    func endEditingNow(){
        
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
    }
    
    /*
     * Move to next input field
     */
    func nextField(){
        focusTextField(nextPrev: 1)
    }
    
    /*
     * Move to previous input field
     */
    func previousField(){
        focusTextField(nextPrev: -1)
    }
    
    /*
     * Focus on next or previous input field
     * @params:
     *      nextPrev:Int
     * @return:
     *      void
     */
    
    func focusTextField(nextPrev:Int){
        
        var nextResponder: UIResponder!
        var tag = 0
        
        tag = tempLastOpenTF.tag + nextPrev
        
        if(tag == 100){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        } else if(tag == 101){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        } else {
            self.endEditingNow()
        }
        
    }
    
    
    //show next button on above of keyboard
    func nextBtnKeyBoard(){
        nextOnTextFields(tempLastOpenTF)
    }
    
    //when user tap next it will come in textFieldShouldReturn then bellow function
    func nextOnTextFields(_ textField: UITextField){
        tempLastOpenTF = textField
        //Heighlight fields on next
        if textField == userNameTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            textField.resignFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }

    @IBAction func signUp(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("false", forKey: "isFBLogin")
        
        defaults.synchronize()

    }
    
    @IBAction func login(_ sender: Any) {
        
        let email = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: userNameTF.text! )
        let password = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: passwordTF.text! )
        if email == "" {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:Constants.Please_enter_email_address, btnTitle:Constants.OK)
            userNameTF.becomeFirstResponder()
        }
//        else if UIUtility.sharedInstance.isValidEmail( emailAdd: email ) == false {
//            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:Constants.Please_enter_valid_email_address, btnTitle:Constants.OK)
//            userNameTF.becomeFirstResponder()
//        }
        else if password == "" {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:Constants.Please_enter_password, btnTitle:Constants.CLOSE)
            passwordTF.becomeFirstResponder()
        }
        else {
            let defaults = UserDefaults.standard
            defaults.set("Norml", forKey: "typeLogin")

            showLoader(show: true)
            let api = API()
            api.signinUser(userName: email, password: password, callback: self.signInCallBack)
        }
        
    }
    
    func signInCallBack(_ userInfos: User, _ message:String, _ status:String){
        showLoader(show: false)
//        loadImagesFromURL()

        if status == "1" {
            let defaults = UserDefaults.standard
            defaults.set("Y", forKey: "isLogin")
            defaults.synchronize()

            delLoadStickers()
            

//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            self.show(newViewController, sender: self)

        } else {
            showLoader(show: false)

            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
        }
    }
    
    func delLoadStickers(){
        showLoader(show: true)
        deleteAllStickers()
        loadImagesFromURL()
    }

    @IBAction func showForgotPassword(_ sender: Any) {
        forgotPasswordView.isHidden = false
    }
    
    @IBAction func hideForgotPassword(_ sender: Any) {
        forgotPasswordView.isHidden = true
    }

    @IBAction func forgotPassword(_ sender: Any) {
        
        let email = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: emailTF.text! )
        if email == "" {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:Constants.Please_enter_email_address, btnTitle:Constants.OK)
            userNameTF.becomeFirstResponder()
        }
        else if UIUtility.sharedInstance.isValidEmail( emailAdd: email ) == false {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:Constants.Please_enter_valid_email_address, btnTitle:Constants.OK)
            userNameTF.becomeFirstResponder()
        }
        else {
            showLoader(show: true)
            let api = API()
            api.forgotPassword(email: email, callback: self.forgotPasswordCallBack)
        }
        
    }
    
    func forgotPasswordCallBack(_ userInfos: User, _ message:String, _ status:String){
        showLoader(show: false)
        
        if status == "1" {
            hideForgotPassword(self)
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.OK)

//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            self.show(newViewController, sender: self)
            
            //            let vc = UpdateProfileViewController(nibName: "UpdateProfileViewController", bundle: nil)
            //            self.navigationController?.pushViewController(vc, animated: true)
        } else {

            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
        }
    
    }
    
    @IBAction func btnFBPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: Constants.LoginWthFB, style: .default, handler: { action in
            switch action.style{
            case .default:
                self.btnFBLoginPressed()

                print("lfb")
                //self.navigationController!.popViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: Constants.ShareOnFB, style: .default, handler: { action in
            switch action.style{
            case .default:
                self.shareOnFB()
                print("sfb")
                //self.navigationController!.popViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func shareOnFB(){
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(UIImage.init(named: "funclublogo.png"))
        
        vc?.add(URL(string: "http://www.example.com/"))
        
        vc?.setInitialText("Amazing app.")
        
        self.present(vc!, animated: true, completion: nil)
    }
     func btnFBLoginPressed() {
//        if( fbButton.titleLabel?.text == Constants.Logout_From_Facebook ){
//            self.logoutFromFb()
//        }
         if((FBSDKAccessToken.current()) != nil){
            self.getFBUserInfo(redirect: true)
        }
        else {
            FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (FBSDKLoginManagerLoginResult, error: Error?) in
                self.getFBUserInfo(redirect: true)
                
            })
            
            //            FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email"],
            //                                                         fromViewController:self,
            //                                                         handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            //
            //                                                            if(error != nil){
            //                                                                // Handle error
            //                                                            }
            //                                                            else if(result.isCancelled){
            //                                                                // Authorization has been canceled by user
            //                                                            }
            //                                                            else {
            //                                                                // Authorization successful
            //                                                                //No need of it, we are checking in viewWillAppear
            //                                                            }
            //            })
        }//else
    }//end fn
    
    /**
     * Set title of facebook btn a/c to its token
     * @params: void
     */
    func setFbBtnTitle(){
        var btnFacebookTitle = Constants.Connect_With_Facebook
        if(FBSDKAccessToken.current() != nil) {
            btnFacebookTitle = Constants.Logout_From_Facebook
            self.getFBUserInfo(redirect: true)
        }
       // fbButton.setTitle(btnFacebookTitle, for: .normal)
    }
    
    /**
     * Get user information from facebook when have access token
     * @param:
     *    @redirect:Bool, after getting user info redirect to My Account
     */
    func getFBUserInfo(redirect:Bool){
        
        if((FBSDKAccessToken.current()) != nil){
            self.showLoader(show: true)
            
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email, name, gender, id"]).start { (connection, result, error) -> Void in
                
                self.showLoader(show: false)
                if result != nil {
                    let detail = result! as! NSDictionary
                    let firstName: String = (detail["first_name"] as? String)!
                    let lastName: String = (detail["last_name"] as? String)!
                    let email: String = (detail["email"] as? String)!
                    let name: String = (detail["name"] as? String)!
                    let gender: String = (detail["gender"] as? String)!
                    let fbId: String = (detail["id"] as? String)!
                    let picture: NSDictionary = (detail["picture"] as? NSDictionary)!
                    let pictureData: NSDictionary = (picture["data"] as? NSDictionary)!
                    let pictureUrl: String = (pictureData["url"] as? String)!

                    var parameters = Dictionary<String, AnyObject>()
                    parameters["fullname"] = firstName as AnyObject?
                    parameters["picture"] = pictureUrl as AnyObject?
                    parameters["email"] = email as AnyObject?
                    parameters["username"] = name as AnyObject?
                    parameters["gender"] = gender as AnyObject?
                    parameters["id"] = fbId as AnyObject?
                    parameters["phoneNumber"] = "" as AnyObject

                   // let parameters = ["userName":userName, "fullName": name,"email":email, "phoneNumber": mobileNo,"password":password, "gender": "Male" ]

                    var param = Dictionary<String, AnyObject>()
                    var userProfile: String = ""
                    do {
                        let json = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
                        userProfile = NSString(data: json, encoding: String.Encoding.utf8.rawValue)! as String
                    } catch {
                        print(error.localizedDescription)
                        
                    }
                    var parametersFB = Dictionary<String, AnyObject>()
                    var fbParams : String = ""
                    parametersFB["access_token"] = FBSDKAccessToken.current().tokenString! as AnyObject?
                    parametersFB["expires"] = FBSDKAccessToken.current().expirationDate!.description as AnyObject?
                    do {
                        let json = try JSONSerialization.data(withJSONObject: parametersFB, options: JSONSerialization.WritingOptions(rawValue: 0))
                        fbParams = NSString(data: json, encoding: String.Encoding.utf8.rawValue)! as String
                    } catch {
                        print(error.localizedDescription)
                        
                    }
                    param["user_profile_data"] = userProfile as AnyObject?
                    param["access_token_data"] = fbParams as AnyObject?
                    
                    if redirect {
                        
                        
                        let defaults = UserDefaults.standard
                        defaults.set(pictureUrl, forKey: "picFB")
                        defaults.set(firstName, forKey: "userName")
                        defaults.set(email, forKey: "userEmail")
                        defaults.set(gender, forKey: "gender")
                        defaults.set(name, forKey: "fullName")
                        defaults.set("FB", forKey: "typeLogin")
                        
                        defaults.set("true", forKey: "isFBLogin")
                        
                        defaults.synchronize()

//                        self.performSegue(withIdentifier: "push", sender: self)
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
//                        self.show(newViewController, sender: self)
                        let api = API()
                        self.showLoader(show: true)
                        
                        api.facebookLogin(parameters: parameters as AnyObject, callback: self.signInCallBack)
//                        self.signup(["firstName":firstName, "lastName":lastName, "email":email,"fbToken":FBSDKAccessToken.current().tokenString!], apiUrl:Constants.FB_SIGN_IN_URL, userType: Constants.USER_FACEBOOK, fbToken:FBSDKAccessToken.currentAccessToken().tokenString)
                    }
                }//result != nil
            }
            // Track user profile
            // EventTracker.sharedInstance.userProfiler()
        }// token != nil
    }
    
    /**
     * logout from facebook
     * @param:void
     */
    func logoutFromFb(){
        if((FBSDKAccessToken.current()) != nil){
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.setFbBtnTitle()
        }
    }
    
    /**
     * Delegate function of default fb login button
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        self.getFBUserInfo(redirect: true)
    }
    
    
    /**
     * Delegate function of default fb logout button
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        self.logoutFromFb()
    }
    
    func userRegisterFB(message:String){
        self.showLoader(show: false)
        
        if message == "Customer already exist with FID" || message == "Customer already exist with GID" {
            self.navigationController!.popViewController(animated: true)
            
            //            let vc = HomePageViewController(nibName: "HomePageViewController", bundle: nil)
            //            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
    }
    
   
    
    
    @IBAction func btnGooglePressed(_ sender: AnyObject) {
        let alert = UIAlertController(title:"", message: "What would you like to do?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: Constants.LoginWthGoogle, style: .default, handler: { action in
            switch action.style{
            case .default:
                GIDSignIn.sharedInstance().signIn()
                print("lg+")
            //self.navigationController!.popViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        
        alert.addAction(UIAlertAction(title: Constants.ShareOnGooglePlus, style: .default, handler: { action in
            switch action.style{
            case .default:
                self.shareOnGooglePlus()
                print("sg+")
            //self.navigationController!.popViewController(animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func shareOnGooglePlus(){
//        var shareDialog : GPPShareBuilder = GPPShare().shareDialog()
//        
//        shareDialog.setPrefillText("Check This out")
//        
//        shareDialog.setURLToShare(NSURL(string: "https://developers.ggoe.com/+/"))
//        
//        shareDialog.setCallToActionButtonWithLabel("BookMark", URL: NSURL(string: "https://developers.google.com/+/mobile/ios/"),deepLinkID: "")
//        
//        shareDialog.open()
        
        
        let urlstring = "https://aboutme.google.com/?referer=gplus"
        
        let shareURL = NSURL(string: urlstring)
        
        let urlComponents = NSURLComponents(string: "https://plus.google.com/share")
        
        urlComponents!.queryItems = [NSURLQueryItem(name: "url", value: shareURL!.absoluteString) as URLQueryItem]
        
        let url = urlComponents!.url!
        
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            svc.delegate = self as? SFSafariViewControllerDelegate
            self.present(svc, animated: true, completion: nil)
        } else {
            debugPrint("Not available")
        }

//        var urlComponents = URLComponents(string: "https://plus.google.com/share")
//        urlComponents.queryItems = [URLQueryItem(name: "url", value: shareURL.absoluteString)]
//        var url: URL? = urlComponents.url
//        if SFSafariViewController.self {
//            // Open the URL in SFSafariViewController (iOS 9+)
//            var controller = SFSafariViewController(url: url)
//            controller?.delegate = self
//            present(controller!, animated: true, completion: { _ in })
//        }
//        else {
//            // Open the URL in the device's browser
//            UIApplication.shared.openURL(url!)
//        }

    }
    
    
    // [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        print("Signed out.")
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        print("Disconnecting.")
        // [END_EXCLUDE]
    }
    // [END disconnect_tapped]
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            // signInButton.isHidden = true
        } else {
            //signInButton.isHidden = false
            print("Google Sign in\niOS Demo")
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo["statusText"]!)
            }
        }
    }

    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let firstName = user.profile.givenName
            let lastName = user.profile.familyName
            let email = user.profile.email
            let gender = ""
            
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(name)"])
            // [END_EXCLUDE]
            
            var parameters = Dictionary<String, AnyObject>()
            parameters["fullname"] = firstName as AnyObject?
//            parameters["picture"] = pictureUrl as AnyObject?
            parameters["email"] = email as AnyObject?
            parameters["username"] = name as AnyObject?
            parameters["gender"] = gender as AnyObject?
            parameters["id"] = userId as AnyObject?
            parameters["phoneNumber"] = "" as AnyObject
            
            var param = Dictionary<String, AnyObject>()
            var userProfile: String = ""
            do {
                let json = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
                userProfile = NSString(data: json, encoding: String.Encoding.utf8.rawValue) as! String
            } catch {
                print(error.localizedDescription)
                
            }
            var parametersGP = Dictionary<String, AnyObject>()
            var gpParams : String = ""
            parametersGP["access_token"] = user.authentication.accessToken! as AnyObject?
            parametersGP["expires"] = user.authentication.idTokenExpirationDate.description as AnyObject?
            do {
                let json = try JSONSerialization.data(withJSONObject: parametersGP, options: JSONSerialization.WritingOptions(rawValue: 0))
                gpParams = NSString(data: json, encoding: String.Encoding.utf8.rawValue) as! String
            } catch {
                print(error.localizedDescription)
                
            }
            param["user_profile_data"] = userProfile as AnyObject?
            param["access_token_data"] = gpParams as AnyObject?
            
//            
            let defaults = UserDefaults.standard
            // defaults.set(picture, forKey: "pic")
            defaults.set(firstName, forKey: "userName")
            defaults.set(email, forKey: "userEmail")
            defaults.set(gender, forKey: "gender")
            defaults.set(name, forKey: "fullName")
            //   defaults.set(phoneNumber, forKey: "phone")
            defaults.set("FB", forKey: "typeLogin")

            defaults.set("true", forKey: "isFBLogin")
//            self.performSegue(withIdentifier: "push", sender: self)

//
            defaults.synchronize()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            self.show(newViewController, sender: self)
            
            let api = API()
            self.showLoader(show: true)

            api.facebookLogin(parameters: parameters as AnyObject, callback: self.signInCallBack)
            self.showLoader(show: true)
//            let api = API()
//            api.loginWithGooglePlus(parameters: param as AnyObject, callback: self.userRegisterGP)
            
            
        }
    }
    
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    
    
    func LoginWithGP(parameters:AnyObject) {
        
        let api = API()
        self.showLoader(show: true)
        
      //  api.loginWithGooglePlus(parameters: parameters as AnyObject, callback: self.signInCallBack)
        
    }
    
    func userRegisterGP(_ userInfo:User, _ message: String, _ status:String){
        self.showLoader(show: false)
        
        if message == "Customer already exist with FID" || message == "Customer already exist with GID" {
            self.navigationController!.popViewController(animated: true)
            
        }
        else {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
        
        
        
    }

    
    
    func loadImagesFromURL() {
        let api = API()
        let defaults = UserDefaults.standard
        let userID = defaults.value(forKey: "userId") as! String
        api.loadDashboardSticker(userId: userID, callback: self.dashboardStickers)
        
    }
    func dashboardStickers(_ dashboardStickersArr: Array<DashboardStickers>, _ message:String, _ status:String){
        
        if status == "1" {
//            deleteAllStickers()
            imgCount = dashboardStickersArr.count
            for dashboardSticker in dashboardStickersArr {
                let uRl = URL(string: dashboardSticker.image)
                let request = URLRequest(url: uRl!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let _ = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() { () -> Void in
                        
                        DispatchQueue.main.async() {
                            [weak self] in
                            // Return data and update on the main thread, all UI calls should be on the main thread
                            // you could also just use self?.method() if not referring to self in method calls.
                            if let weakSelf = self {
                                
                                self?.addToCoreData(imageData: data, imageId: dashboardSticker.id)
                            }
                        }
                        
                    }
                    
                    }.resume()
            }
            
        }
        else {
            showLoader(show: false)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.show(newViewController, sender: self)
            //            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
    }
    
    func addToCoreData(imageData: Data, imageId:String){
        let context =  self.appDelegate.moc
        let dashboardImages = User(context: context)
        _ = dashboardImages.createImageData(imageData: imageData, imageId: imageId)
        
        let dashboarST : [UserDashboardImages]  = dashboardImages.getAll()
        
        if dashboarST.count == imgCount {
//            getAllDashboardImages()
            showLoader(show: false)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.show(newViewController, sender: self)

        }
        
    }
    func deleteAllStickers() -> Void {
        // let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDashboardImages")
        
        let result = try? appDelegate.moc.fetch(fetchRequest)
        let resultData = result as! [UserDashboardImages]
        
        for object in resultData {
            print("deleted Img ID\(String(describing: object.imageId!))")
            appDelegate.moc.delete(object)
        }
        
        do {
            try appDelegate.moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }


}
