
//  InteriorDesignViewController.swift
//  FunClub
//
//  Created by Usman Khalil on 09/07/2017.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit

class InteriorDesignViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate, FCColorPickerViewControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    var imagePicker = UIImagePickerController()
    var overlay : UIView? //loading overlay
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let pushNoti = Notification.Name("PushNotification")

    @IBOutlet var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white

        if revealViewController() != nil {
//            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
//        
//            menuButton.target = (appDelegate.window?.rootViewController as! UINavigationController).viewControllers.filter({ (item) -> Bool in
//                if item.isKind(of: SWRevealViewController.self){
//                    menuButton.action = #selector((item as! SWRevealViewController).revealToggle(_:))
//                }
//                return item.isKind(of: SWRevealViewController.self)
//            }).first as! SWRevealViewController
        
//            view.addGestureRecognizer(revealViewController?.panGestureRecognizer)
        
        
        self.overlay = Loading.sharedInstance.createOverlayForLoader(frame: CGRect(x:0,y:0, width:600, height:800))
       
        imagePicker.delegate = self
        setProfile()
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "StickerType") != nil {
            let typeSticker = defaults.value(forKey: "StickerType")
            interiorDesignAPI(categoryType: typeSticker as! String)
            defaults.removeObject(forKey: "StickerType")
            defaults.synchronize()
        }

    }
    
    // toggle left menu
    @IBAction func displaySideMenu(){
        
        
            //            revealViewController().rearViewRevealWidth = 62
//            menuButton.target = revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
    }

    func setProfile(){
        let defaults = UserDefaults.standard
        
        // Do any additional setup after loading the view.
        let picUrl = defaults.value(forKey: "pic") as! String
        let userName = defaults.value(forKey: "userName") as! String
        
        userNameLbl.text = userName
        
        if picUrl != "0" {
            let image_url:NSURL = NSURL(string: picUrl)!
            let url_request = NSURLRequest(url: image_url as URL)
            let placeholder = UIImage(named: "images_not_found_1.png")
            
            imageView.downloadedFrom(link: picUrl)
            self.imageView.layer.cornerRadius = (self.imageView.frame.size.width) / 2;
            self.imageView.clipsToBounds = true;
            
            //        self.profileImgView.image = nil
            //Load image asynchronously
//            self.imageView.setImageWith(url_request as URLRequest, placeholderImage: placeholder,
//                                        success: { [weak self] (request:URLRequest,response:HTTPURLResponse?, image:UIImage) -> Void in
//                                            self?.imageView.layer.cornerRadius = (self?.imageView.frame.size.width)! / 2;
//                                            self?.imageView.clipsToBounds = true;
//                                            self!.imageView.image = image
//                                            //                                        UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
//                }, failure: { [weak self] (request:URLRequest,response:HTTPURLResponse?, error:Error) -> Void in
//                    //                UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
//            })
        }
        
    }
    
    func showLoader(show:Bool){
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
        Loading.sharedInstance.showLoader(show: show, view:self.view, overlay:self.overlay! )
        Loading.sharedInstance.disableLinks( nc: self.navigationController!, enable:(!show) )
    }
//efOIBNUVoTE:APA91bGbNXQC3VuPInhqDtRsS9dhApeadXWqBiv_MrnCM_Pa-KZTgguYAZIBL_st_6u29h3thrcC6QTwQIrgo5qpO8K5JHBpI3UpLZr5vVGxPJFRBwbMVEE-x8Ik6z5vDr5YwHvAL5tR
    @IBAction func interiorDesignBtn(_ sender: Any) {
        var categoryType = ""
        var flag = false
        switch ((sender as AnyObject).tag) {
            case 100:
//                categoryType = "Background"
                changeBackground()
                flag = false
            case 101:
                categoryType = "Tatoo room"
                flag = true
            case 102:
                categoryType = "Emojis"
                flag = true
            case 103:
                cameraBtnTap()
                flag = false
            case 104:
                categoryType = "Headboards"
                flag = true
            case 105:
                categoryType = "Style"
                flag = true
            default: break
        }
        
        if flag {
            interiorDesignAPI(categoryType: categoryType)
        }
    }
    
    func changeBackground(){
        let colorPicker = FCColorPickerViewController.colorPicker()
//        colorPicker.color = User.sharedInstance().canvasColor
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .formSheet
        present(colorPicker as? UIViewController ?? UIViewController(), animated: true) { _ in }

    }
    
    func colorPickerViewController(_ colorPicker: FCColorPickerViewController, didSelect color: UIColor) {
//        User.sharedInstance().canvasColor = color
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        UserDefaults.standard.setValue(colorData, forKey: "DashboardBGColor")
        dismiss(animated: true) { _ in }
    }
    
    func colorPickerViewControllerDidCancel(_ colorPicker: FCColorPickerViewController) {
        dismiss(animated: true) { _ in
        }
    }

    func interiorDesignAPI(categoryType: String) {
        
        let api = API()
        self.showLoader(show: true)
        let parameters = ["category":categoryType]
        api.interiorDesign(parameters: parameters as AnyObject, callback: self.interiorDesignSelect)

    }
    
    func interiorDesignSelect(_ interiorDesignArr: Array<InteriorDesignTatto>, _ message:String, _ status:String){
        self.showLoader(show: false)
        
        if status == "1" {
           
            let interiorDesignSelectionVC = storyboard?.instantiateViewController(withIdentifier: "InteriorDesignSelectionViewController") as! InteriorDesignSelectionViewController
            interiorDesignSelectionVC.interiorDesignArr = interiorDesignArr
            navigationController?.pushViewController(interiorDesignSelectionVC, animated: true)
            
        }
        else {
            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
    }
    
    func cameraBtnTap(){
        
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
    
    func openCamera() {
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
        var  chosenImage = UIImage()
        let img = UIImageView()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //        profileImgView.contentMode = .scaleAspectFit //3
//        profileImgView.image = nil
        img.image = chosenImage //4
        var base64String = ""
        //
        
        if let imageData = img.image?.jpeg(.lowest) {
            print(imageData.count)
            base64String = imageData.base64EncodedString()
            
            
        }

        let api = API()
        showLoader(show: true)

        let defaults = UserDefaults.standard
        let userID = defaults.value(forKey: "userId") as! String
        let parameters = ["member_id":userID, "picture": base64String]
        
        defaults.set(base64String, forKey: "Base64")
        defaults.synchronize()

        
        api.photoUpload(parameters: parameters as AnyObject, callback: self.photoUploadCallBack)
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func photoUploadCallBack(_ message:String, _ status:String){
        if status == "1" {
            showLoader(show: false)
        }
    
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}

