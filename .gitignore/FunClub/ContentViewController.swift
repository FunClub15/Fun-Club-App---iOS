//
//  ContentViewController.swift
//  FunClub
//
//  Created by NISUM on 9/19/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

class ContentViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var hasSubViewAddedInPDSV:Bool = false //has product details view added in scroll view
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    
    var canHideFullScreenOverlay:Bool = false
    var overlay : UIView? //loading overlay
    var delegate: HomeDelegate?
    let navigationHelper = NavigationHelper()
    
    var flag: Bool = false
    var userID: String = "0"
    
    @IBOutlet var imageSpinner: UIActivityIndicatorView!
    
    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var uploadVdoBtn: UIButton!
    @IBOutlet weak var goLiveBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.overlay = Loading.sharedInstance.createOverlayForLoader(frame: CGRect(x:0,y:0, width:600, height:800))
        let singleTapOnOverlay: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UpdateProfileViewController.tapOnOverlay))
        singleTapOnOverlay.cancelsTouchesInView = false
        self.overlay!.addGestureRecognizer(singleTapOnOverlay)
        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        self.galleryButton.layer.cornerRadius = (self.galleryButton.frame.size.width) / 2;
        self.galleryButton.clipsToBounds = true;
        
        self.uploadPhotoBtn.layer.cornerRadius = (self.uploadPhotoBtn.frame.size.width) / 2;
        self.uploadPhotoBtn.clipsToBounds = true;
        
        self.uploadVdoBtn.layer.cornerRadius = (self.uploadVdoBtn.frame.size.width) / 2;
        self.uploadVdoBtn.clipsToBounds = true;
        
        self.goLiveBtn.layer.cornerRadius = (self.goLiveBtn.frame.size.width) / 2;
        self.goLiveBtn.clipsToBounds = true;
        
    }
    
    @IBAction func galleryAction(_ sender: Any) {
    }
    
    @IBAction func uploadPhotoAction(_ sender: Any) {
    }
    
    @IBAction func uploadVdoAction(_ sender: Any) {
    }
    
    @IBAction func goLiveAction(_ sender: Any) {
    }
    
}
