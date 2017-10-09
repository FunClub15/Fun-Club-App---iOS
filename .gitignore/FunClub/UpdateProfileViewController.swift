//
//  UpdateProfileViewController.swift
//  FunClub
//
//  Created by Usman Khalil on 19/06/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var LOGIN_EMAIL_TAG: Int = 100
    var LOGIN_PASSWORD_TAG: Int = 101
    
    @IBOutlet weak var scrollView: UIScrollView!
    var hasSubViewAddedInPDSV:Bool = false //has product details view added in scroll view
    
    @IBOutlet weak var profileImgView: UIImageView!

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var tempLastOpenTF: UITextField! //input field object which in edit mode
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData = ["Male","Female"]
    
    var imagePicker = UIImagePickerController()
    
    var canHideFullScreenOverlay:Bool = false
    var overlay : UIView? //loading overlay
    var delegate: HomeDelegate?
    let navigationHelper = NavigationHelper()
    
    var flag: Bool = false
    var userID: String = "0"

    @IBOutlet var imageSpinner: UIActivityIndicatorView!

    @IBOutlet var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setProfile()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white

        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            //            revealViewController().rightViewRevealWidth = 150
            //            extraButton.target = revealViewController()
            //            extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.automaticallyAdjustsScrollViewInsets = false;
            NotificationCenter.default.addObserver(self, selector: #selector(UpdateProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(UpdateProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        }
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        
        pickerView.isHidden = true
        
        imagePicker.delegate = self

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.overlay = Loading.sharedInstance.createOverlayForLoader(frame: CGRect(x:0,y:0, width:600, height:800))
        let singleTapOnOverlay: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateProfileViewController.tapOnOverlay))
        singleTapOnOverlay.cancelsTouchesInView = false
        self.overlay!.addGestureRecognizer(singleTapOnOverlay)
        // Do any additional setup after loading the view.
    }
    
    func setProfile() {
        let defaults = UserDefaults.standard
        let email = defaults.value(forKey: "userEmail") as! String
        let userName = defaults.value(forKey: "userName") as! String
        let fullName = defaults.value(forKey: "fullName") as! String
        let phone = defaults.value(forKey: "phone") as! String
        let gender = defaults.value(forKey: "gender") as! String
        var picUrl = defaults.value(forKey: "pic") as! String
        userID = defaults.value(forKey: "userId") as! String
        let type = defaults.value(forKey: "typeLogin") as! String
        
        if type == "FB" {
            picUrl = defaults.value(forKey: "picFB") as! String
        }

        
        if picUrl != "0" {
            let image_url:NSURL = NSURL(string: picUrl)!
            let url_request = NSURLRequest(url: image_url as URL)
            let placeholder = UIImage(named: "images_not_found_1.png")
            
            profileImgView.downloadedFrom(link: picUrl)
            self.profileImgView.layer.cornerRadius = (self.profileImgView.frame.size.width) / 2;
            self.profileImgView.clipsToBounds = true;

            //self.profileImgView.image = nil
            //Load image asynchronously
//            self.profileImgView.setImageWith(url_request as URLRequest, placeholderImage: placeholder,
//                                             success: { [weak self] (request:URLRequest,response:HTTPURLResponse?, image:UIImage) -> Void in
//                                                self?.profileImgView.layer.cornerRadius = (self?.profileImgView.frame.size.width)! / 2;
//                                                self?.profileImgView.clipsToBounds = true;
//                                                self!.profileImgView.image = image
//                                                //                                        UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
//                }, failure: { [weak self] (request:URLRequest,response:HTTPURLResponse?, error:Error) -> Void in
//                    //                UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
//            })
        }
        self.emailTF.text = email
        self.userNameTF.text = userName
        self.nameTF.text = fullName
        self.phoneTF.text = phone
        self.genderTF.text = gender
        
        if gender.characters.count == 0 {
            self.genderTF.text = "Gender"
            
        }

    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 40//keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 40//keyboardSize.height
            }
        }
    }
    
    @IBAction func pickerViewVisible(_ sender: Any) {
        self.endEditingNow()
        pickerView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame

    }
    
    func showLoader(show:Bool){
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
        Loading.sharedInstance.showLoader(show: show, view:self.view, overlay:self.overlay! )
        Loading.sharedInstance.disableLinks( nc: self.navigationController!, enable:(!show) )
    }
    
    @IBAction func signup(_ sender: Any)      {
        
        //        self.setBorderColorOfField(cgColor: ThemeEngine.sharedInstance.getTextFieldBorderColor().cgColor)
        var isValid = true
        var msg = ""
        let userName = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.userNameTF.text! )
        let name = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.nameTF.text! )
        let email = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.emailTF.text! )
        let password = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.passwordTF.text! )
        let mobileNo = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.phoneTF.text! )
        let confirmPAssword = UIUtility.sharedInstance.removeNewLineTabAndSpaces( myString: self.confirmPasswordTF.text! )
        var firstEmptyTxtField:UITextField = self.userNameTF
        
        if userName == "" {
            if isValid {
                firstEmptyTxtField = self.userNameTF
            }
            self.userNameTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            isValid = false
        }
        if name == "" {
            if isValid {
                firstEmptyTxtField = self.nameTF
            }
            self.nameTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            isValid = false
        }
        if email == "" {
            if isValid {
                firstEmptyTxtField = self.emailTF
            }
            self.emailTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            isValid = false
        }
        else if UIUtility.sharedInstance.isValidEmail( emailAdd: email ) == false {
            if isValid {
                firstEmptyTxtField = self.emailTF
            }
            msg = Constants.Please_enter_valid_email_address
            isValid = false
        }
        
        
        if mobileNo == "" {
            if isValid {
                firstEmptyTxtField = self.phoneTF
            }
            self.phoneTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            isValid = false
        }
        
        
//        if password.characters.count < 6 {
//            if isValid {
//                firstEmptyTxtField = self.passwordTF
//            }
//            self.passwordTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
//            isValid = false
//            
//            if msg == "" && password != "" {
//                msg = Constants.The_password_must_have_at_least_6_characters
//            }
//        }
//        if confirmPAssword == "" {
//            if isValid {
//                firstEmptyTxtField = self.confirmPasswordTF
//            }
//            self.confirmPasswordTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
//            isValid = false
//        }
        
        if msg == ""  && password != "" && confirmPAssword != "" && password != confirmPAssword {
            if isValid {
                firstEmptyTxtField = self.confirmPasswordTF
            }
            msg = Constants.Password_are_not_matching
            self.passwordTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            self.confirmPasswordTF.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldRedBorderColor().cgColor
            isValid = false
        }
        
        
        if isValid == false && msg != "" {
            firstEmptyTxtField.becomeFirstResponder()
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:msg, btnTitle:Constants.CLOSE)
        }
        else if isValid == true {
            showLoader(show: true)
            let api = API()
//            let parameters = ["userName":userName, "fullname": name,"email":email, "phoneNumber": mobileNo,"password":password, "gender": "Male", "id": userID]//"picture": ""
          //print(parameters.description)
            if flag{
//                let Imagedata = UIImageJPEGRepresentation(profileImgView.image!, 0.8)
//                let strBase64 = Imagedata!.base64EncodedString(options: NSData.Base64EncodingOptions())
//                let imageData:Data =  UIImagePNGRepresentation(profileImgView.image!)!
//                let strBase64 = imageData.base64EncodedString()
//                print(strBase64)
                var base64String = ""
                
                if let imageData = profileImgView.image?.jpeg(.lowest) {
                    print(imageData.count)
                    base64String = imageData.base64EncodedString()
                }

//                let base64 = encode(toBase64String: profileImgView.image!)
//                print(strBase64)
                
//                let plainString = strBase64
                
                // Encoding
//                guard let plainData = (plainString as NSString).data(using: String.Encoding.utf8.rawValue) else {
//                    fatalError()
//                }
//                
//                let base64String = plainData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
               // print("BASE64 = \(base64String)") // Zm9v
                //                let imageData = UIImagePNGRepresentation(profileImgView.image!) as NSData?

//                let imageData = UIImagePNGRepresentation(profileImgView.image!, 1)
                let parameters = ["userName":userName, "fullname": name,"email":email, "phoneNumber": mobileNo,"password":password, "gender": "Male", "id": userID , "picture":base64String ] as [String : Any]
                api.updateProfile(parameters: parameters as AnyObject, callback: self.profileUpdate)
//                let imageData: NSData = UIImageJPEGRepresentation(profileImgView.image!, 0.4)! as NSData
//                let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//                print(imageStr)
//                api.updateProfile(parameters: parameters as AnyObject, callback: self.profileUpdate)

//                self.imageUpload(parameters: parameters)
            }
            else{
                let parameters = ["userName":userName, "fullname": name,"email":email, "phoneNumber": mobileNo,"password":password, "gender": "Male", "id": userID, "picture": ""]
                api.updateProfile(parameters: parameters as AnyObject, callback: self.profileUpdate)
            }

//            api.updateProfile(parameters: parameters as AnyObject, callback: self.profileUpdate)
//            self.imageUpload(parameters: parameters)
        }
        
        
        
        
    }
    
    func encode(toBase64String image: UIImage) -> String {
        return UIImagePNGRepresentation(image)!.base64EncodedString(options: .endLineWithCarriageReturn)
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
        let closeBtn = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignupViewController.endEditingNow) )
        
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
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignupViewController.endEditingNow))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        var nextButton  = UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignupViewController.nextField))
        nextButton.width = 50.0
        var previousButton  = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignupViewController.previousField))
        
        toolbar.setItems([fixedSpaceButton, previousButton, fixedSpaceButton, nextButton, flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    func endEditingNow(){
        phoneTF.resignFirstResponder()
        
        userNameTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        confirmPasswordTF.resignFirstResponder()
        
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
        
        print("tag\(tag)")
        if(tag == 1){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        }
        else if(tag == 2){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        }
        else if(tag == 3){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        }
        else if(tag == 4){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        }
        else if(tag == 5){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.becomeFirstResponder()
        }
        else if(tag == 6){
            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            nextResponder.resignFirstResponder()
            self.endEditingNow()
            
            pickerView.isHidden = false
        }
            //        else if(tag == 7){
            //            nextResponder = tempLastOpenTF.superview!.viewWithTag(tag)!
            //            nextResponder.becomeFirstResponder()
            //        }
        else
        {
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
            emailTF.becomeFirstResponder();
        } else if textField == emailTF {
            passwordTF.becomeFirstResponder();
        } else if textField == passwordTF {
            confirmPasswordTF.becomeFirstResponder()
        } else if textField == confirmPasswordTF {
            nameTF.becomeFirstResponder();
        } else if textField == nameTF {
            phoneTF.becomeFirstResponder()
        }
        else if textField == phoneTF {
            textField.resignFirstResponder()
            //self.onLoginTap("")
        }
        else {
            textField.resignFirstResponder()
        }
    }
    
    func profileUpdate(message:String){
        self.showLoader(show: false)
        
        if message == "Successfully Inserted" {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:"Your profile has been successfully updated.", btnTitle:Constants.CLOSE)
            
        }
        else {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
        }
    }
    
    // toggle left menu
    func displaySideMenu(){
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func showFullScreenOverlay(show:Bool){
        self.canHideFullScreenOverlay = show
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
        if show {
            self.view.addSubview(self.overlay!)
        } else {
            self.overlay!.removeFromSuperview()
        }
    }
    
    func tapOnOverlay(){
        if canHideFullScreenOverlay {
            self.displaySideMenu()
            showFullScreenOverlay(show: false)
        }
    }
    
    //Pickerview functionality
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected value: \(pickerData[row])")
        genderTF.text = pickerData[row]
        pickerView.isHidden = true
    }
    
    //Profile Pickture
    @IBAction func pictureBtnTap(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("abc")
        flag = true
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        profileImgView.contentMode = .scaleAspectFit //3
        profileImgView.image = nil
        profileImgView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func imageUpload(parameters: Any){
//        self.showLoader(show: true)
        let myUrl = NSURL(string: Constants.updateProfileURL);
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(profileImgView.image!, 1)
        
        if(imageData==nil)  { return; }
        
//        let imageData: NSData = UIImageJPEGRepresentation(profileImgView.image!, 0.4)! as NSData
//        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        print(imageStr)
        request.httpBody = createBodyWithParameters(parameters: parameters as? [String : String], filePathKey: "picture", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        //
           // myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary

                let msg = json!.value(forKey: "message") as! String
//                if msg == "Field all must be required" {
//                    UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:msg, btnTitle:Constants.CLOSE)
//
//                }
//                else {
//                    UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:"Profile updated successfully", btnTitle:Constants.CLOSE)
//
//                }
                if msg == "Successfully Inserted" {
                    UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:"Your profile has been successfully updated.", btnTitle:Constants.CLOSE)
                    
                }
                else {
                    UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:msg, btnTitle:Constants.CLOSE)
                }

               // print(json)
                
                DispatchQueue.main.async(execute: {
                    self.showLoader(show: false)

    //                self.myActivityIndicator.stopAnimating()
    //                self.myImageView.image = nil;
                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
}


    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
            let body = NSMutableData();
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
            }
            
            let filename = "user-profile.jpg"
            let mimetype = "image/jpg"
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString("\r\n")
            
            
            
            body.appendString("--\(boundary)--\r\n")
            
            return body as NSData
    }



    func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
    }

    extension Data {
        mutating func append(string: String) {
            let data = string.data(
                using: String.Encoding.utf8,
                allowLossyConversion: true)
            append(data!)
        }
    }

    extension NSMutableData {
        
        func appendString(_ string: String) {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            append(data!)
        }
    }

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString()
    }
}
