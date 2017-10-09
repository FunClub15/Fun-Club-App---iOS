//
//  NoInternetViewController.swift
//  FunClub
//
//  Created by NISUM on 6/16/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit

//Delegate function of drawer menu
@objc
protocol NoInternetViewControllerDelegate {
    @objc optional func reloadOnInternetFound()
    @objc optional func internetScrCancel()
}

class NoInternetViewController: UIViewController {
    
    @IBOutlet var retryBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    var delegate: NoInternetViewControllerDelegate?
    var msg:String = ""
    @IBOutlet var msgLabel: UILabel!
    
    let navigationHelper = NavigationHelper()
    @IBOutlet var searchIconImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo@3x.png")
        self.navigationItem.titleView = UIImageView(image:logo)
        var tempF = self.navigationItem.titleView?.frame
        tempF?.size.height = 38
        self.navigationItem.titleView?.frame = tempF!
        
        self.retryBtn.layer.borderWidth = 1
        self.retryBtn.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldBorderColor().cgColor
        
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = ThemeEngine.sharedInstance.getTextFieldBorderColor().cgColor
        
        
        //When request faild due to any api response
        if msg == Constants.AFN_REQ_FAILED {
            msg = Constants.ERROR_SOME_THING_WENT_WRONG
        }
        
        if msg != "" && msg != Constants.AFN_NO_INTERNET_MSG {
            msgLabel.text = msg
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationHelper.viewWillDisappear(animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRetry(sender: AnyObject) {
        let api = API()
        let isConnectedToNetwork:Bool = api.isConnectedToNetwork()
        if isConnectedToNetwork {
            self.dismiss(animated: false, completion: {
                self.delegate?.reloadOnInternetFound?()
            })
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismiss(animated: false, completion: {
            self.delegate?.internetScrCancel?()
        })
    }
    //MARK: KeyBoard Delegate Functoins
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Create a button bar for the Keyboard
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NoInternetViewController.endEditingNow) )
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    func endEditingNow(){
        
    }
    
}
