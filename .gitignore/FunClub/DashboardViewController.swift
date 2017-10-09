//
//  DashboardViewController.swift
//  FunClub
//
//  Created by NISUM on 6/21/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking
import SwiftyJSON
import CoreData
import AudioToolbox

//Delegate function of drawer menu
@objc
protocol HomeDelegate {
    @objc optional func toggleLeftPanel() -> Bool
    @objc optional func collapseSidePanels()
    @objc optional func loadCategoriesForMenu()
}

class DashboardViewController: UIViewController ,UIGestureRecognizerDelegate, UITextFieldDelegate{

    var canHideFullScreenOverlay:Bool = false
    var overlay : UIView? //loading overlay
    var delegate: HomeDelegate?
    let navigationHelper = NavigationHelper()

    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var images = [Any]()
    var dragabbleImageViews = [Any]()
    var selectedImageIndex: Int = 0

    private lazy var menuController:UIMenuController = {
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "Delete", action: #selector(self.deleteImage(_:)))
        menu.menuItems = [deleteItem]
        menu.arrowDirection = .down
        return menu
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userID: String = "0"

    var dashBoardStickersDataArr : [Data] = []
    var dashBoardStickersIdArr : [String] = []
    
    var dashboardImages : [UserDashboardImages] = []
    
    var imgCount : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        let colorData = UserDefaults.standard.value(forKey: "DashboardBGColor") as? Data ?? Data()
        var color: UIColor? = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        if(color == nil) {
            color = UIColor.white
        }

        self.view.backgroundColor = color
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
//  xx      appDelegate.window?.rootViewController = self.navigationController 
//        appDelegate.window?.makeKeyAndVisible()
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.overlay = Loading.sharedInstance.createOverlayForLoader(frame: CGRect(x:0,y:0, width:600, height:800))

        //        menuController = UIMenuController.shared
//        menuController?.arrowDirection = .default
//        let editMenu = UIMenuItem(title: "delete", action: #selector(self.deleteImage))
//        menuController?.menuItems = [editMenu]
//        
//        getAllDashboardImages()
//        loadImages()
//        deleteAllStickers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        userID = defaults.value(forKey: "userId") as! String

        getAllDashboardImages()
//        loadImagesFromURL()

        setDP()

    }
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        saveImages()
    }

    func setDP(){
        let defaults = UserDefaults.standard
        var picUrl = defaults.value(forKey: "pic") as! String
        let type = defaults.value(forKey: "typeLogin") as! String
        
        if type == "FB" {
            picUrl = defaults.value(forKey: "picFB") as! String
        }

        print(picUrl)
        self.profileImage.image = nil
        //        self.profileImgView.layoutSubviews()
        
        if picUrl != "0" {
            let image_url:NSURL = NSURL(string: picUrl)!
            let url_request = NSURLRequest(url: image_url as URL)
            let placeholder = UIImage(named: "images_not_found_1.png")
            
            
            //            profileImgView.downloadedFrom(link: picUrl)
            //            self.profileImgView.layer.cornerRadius = (self.profileImgView.frame.size.width) / 2;
            //            self.profileImgView.clipsToBounds = true;
            
            //Load image asynchronously
            self.profileImage.setImageWith(url_request as URLRequest, placeholderImage: placeholder,
                                             success: { [weak self] (request:URLRequest,response:HTTPURLResponse?, image:UIImage) -> Void in
                                                self?.profileImage.image = nil
                                                
                                                self?.profileImage.layer.cornerRadius = (self?.profileImage.frame.size.width)! / 2;
                                                self?.profileImage.clipsToBounds = true;
                                                self!.profileImage.image = image
                                                self?.profileImage.layoutSubviews()
                                                
                                                
                                                //                                        UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
                }, failure: { [weak self] (request:URLRequest,response:HTTPURLResponse?, error:Error) -> Void in
                    //                UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
            })
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
    
    func saveImages(){
        for index in 0..<dragabbleImageViews.count {
            let imageView = dragabbleImageViews[index] as? UIImageView ?? UIImageView()
            let frame: CGRect = imageView.frame
            let imageFrameStr: String = NSStringFromCGRect(frame)
            let imageNameStr: String = ((images[index] as AnyObject).value(forKey: "image") as? String)!
            
//            var abc = images[index]
//            var imageNameStr = abc["image"] as! String

            let transform: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: imageView.transform.tx, ty: imageView.transform.ty)            //CGAffineTransform trsn = imageView.transform;
            let image: [AnyHashable: Any] = ["image": imageNameStr, "frame": imageFrameStr, "transform": NSStringFromCGAffineTransform(transform)]
            images[index] = image
        }

    }
   
    func loadImagesFromURL() {
        let api = API()
        let defaults = UserDefaults.standard
        userID = defaults.value(forKey: "userId") as! String
        api.loadDashboardSticker(userId: userID, callback: self.dashboardStickers)
        
    }
    func dashboardStickers(_ dashboardStickersArr: Array<DashboardStickers>, _ message:String, _ status:String){
        
        if status == "1" {
            deleteAllStickers()
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
//            UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:message, btnTitle:Constants.CLOSE)
            
        }
    }
    
    func addToCoreData(imageData: Data, imageId:String){
        let context =  self.appDelegate.moc
        let dashboardImages = User(context: context)
        _ = dashboardImages.createImageData(imageData: imageData, imageId: imageId)
        
        let dashboarST : [UserDashboardImages]  = dashboardImages.getAll()
        
        if dashboarST.count == imgCount {
            getAllDashboardImages()
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

    func getAllDashboardImages(){
        let context =  appDelegate.moc

        let dashboardImage = User(context: context)

        dashboardImages  = dashboardImage.getAll()
        
        print("TOTAL COUNT=\(dashboardImages.count)")
        selectedImageIndex = -1
        images = [Any]()
        dragabbleImageViews = [Any]()
        
        var posX = 10
        var posY = 65
        var frame :CGRect
        for tag in 0..<dashboardImages.count {
            let img = UIImage(data: dashboardImages[tag].imageData! as Data)
//            var imageDic = dashboardImages[tag] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
//                        let frame = CGRectFromString((imageDic["frame"] as? String)!)
//                        let transform = CGAffineTransformFromString(imageDic["transform"] as? CGAffineTransform ?? CGAffineTransform())
       
            
            let dragabbleImageView = DragabbleImageView(image: img)
            
            if posX < 300{
                 frame = CGRect(x: posX, y: posY, width: 100, height: 100)
//                let transform = CGAffineTransform.identity
                posX += 110


            }
            else {
                
                posX = 10
                posY += 110
                frame = CGRect(x: posX, y: posY, width: 100, height: 100)

            }
            
//            let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//            let transform = CGAffineTransform.identity
            dragabbleImageView.frame = frame
            
//            dragabbleImageView.layer.cornerRadius = (dragabbleImageView.frame.size.width) / 2;
            dragabbleImageView.clipsToBounds = true;
            dragabbleImageView.backgroundColor = UIColor.clear
//            let imgId = Int(peo.imageId!)
//            var frame = CGRectFromString(imageDic.values(value(forKey: "frame") as? CGRect ?? CGRect.zero))

//            let transform = CGAffineTransformFromString(imageDic["transform"] as! String)
//
//
//            let dragabbleImageView = DragabbleImageView(image: img)
//            dragabbleImageView.frame = frame
//            dragabbleImageView.tag = tag
//            dragabbleImageView.transform = transform

            
            
            
            print("Image Tag = \(tag)")
            print("Image ID = \(String(describing: dashboardImages[tag].imageId))")
            dragabbleImageView.tag = tag
//            dragabbleImageView.transform = transform
            dragabbleImageView.longPressGesture?.addTarget(self, action: #selector(self.longpressGestureReconized))
            dragabbleImageView.pinchGesture?.addTarget(self, action: #selector(self.handlePinchGesture))
            dragabbleImageView.rotationGesture?.addTarget(self, action: #selector(self.handleRotationGesture))
            dragabbleImageView.rotationGesture?.delegate = self //as? UIGestureRecognizerDelegate
            view.addSubview((dragabbleImageView))
            dragabbleImageViews.append(dragabbleImageView)

        }

    }
    


    func longpressGestureReconized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let location: CGPoint = sender.location(in: sender.view)
            selectedImageIndex = (sender.view?.tag)!

            menuController.setTargetRect(CGRect(x: location.x, y: location.y, width: 100, height: 100), in: sender.view!)
            menuController.setMenuVisible(true, animated: true)
            
        }
    }

    func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let scale: CGFloat = sender.scale
            sender.view?.transform = (sender.view?.transform.scaledBy(x: scale, y: scale))!
            sender.scale = 1.0
        }
    }

    func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let rotation: CGFloat = sender.rotation
            sender.view?.transform = (sender.view?.transform.rotated(by: rotation))!
            sender.rotation = 0
        }
    }

    func deleteImage(_ sender: Any) {
        if selectedImageIndex != -1 {
            let selectedImageView = dragabbleImageViews[selectedImageIndex] as? DragabbleImageView
//            let selectedImage = images[selectedImageIndex] //as? [AnyHashable: Any] ?? [AnyHashable: Any]()
            selectedImageView?.removeFromSuperview()
//            dragabbleImageViews.remove(at: selectedImageIndex)
//            dragabbleImageViews.remove(at: dragabbleImageViews.index(of: selectedImageView)!)
//            images.remove(at: selectedImageIndex)
//            images.remove(at: images.index(of: selectedImage)!)
//            User.sharedInstance.dashboardImages = images
//            saveImages()
//            loadImages()
            deleteSticker(tag: selectedImageIndex)
//            deleteStickerFromServer(tag: selectedImageIndex)
            selectedImageIndex = -1
            
        }
        menuController.setMenuVisible(false, animated: true)
    }
    
    func deleteSticker(tag: Int) {
        let imgID = dashboardImages[tag].imageId
        if imgID != nil {
            deleteStickerFromServer(imgID: imgID!)
        
        let context =  self.appDelegate.moc
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"UserDashboardImages")
        fetchRequest.predicate = NSPredicate(format: "imageId = %@", "\(String(describing: imgID!))")
        do
        {
            let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
            
            for entity in fetchedResults! {
                
                context.delete(entity)
                do {
                    try context.save()
                    
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        catch _ {
            print("Could not delete")
            
        }
    }

    }

    func deleteStickerFromServer(imgID: String){
        
        let ur = "http://dev.technology-minds.com/funclub/manage/webservices/dashboard_delete.php?id=\(String(describing: imgID))&member_id=\(userID)"
        

                    let uRl = URL(string: ur)
                    let request = URLRequest(url: uRl!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                    
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let _ = UIImage(data: data)
                            else { return }
                        DispatchQueue.main.async() { () -> Void in
                            //                self.image = image
                        }
                }.resume()
        
        }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any!) -> Bool {
        if action == #selector(self.deleteImage) {
            return true
        }
        return false
    }

    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: Gesture Reconizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


/*
 func getAllDashboardImages(){
 let context =  appDelegate.moc
 
 let dashboardImage = User(context: context)
 
 let dashboardImages : [UserDashboardImages] = dashboardImage.getAll()
 
 print(dashboardImages.count)
 selectedImageIndex = -1
 images = [Any]()
 dragabbleImageViews = [Any]()
 for peo  in dashboardImages {
 print(peo.imageName!)
 //   let imageDic = images[index] as! [AnyHashable: Any]
 //            let imageDic = images[index] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
 // let imgpath: String = imageDic["image"] as! String//imageDic.values(forKey: "image") as? String ?? ""
 var img: UIImage?
 //            if imgpath.contains("/") {
 //                //should load from document dir
 img = UIImage(named:peo.imageName!)//MediaUtils.getMediaImage(byPath: imgpath)
 //            }
 //            else {
 //                //should load from project resource
 //                img = UIImage(named: imgpath)
 //            }
 //            let frame = CGRectFromString((imageDic["frame"] as? String)!)
 //            let transform = CGAffineTransformFromString(imageDic["transform"] as? CGAffineTransform ?? CGAffineTransform())
 let dragabbleImageView = DragabbleImageView(image: img)
 //            dragabbleImageView.frame = frame
 //            dragabbleImageView.tag = index
 //            dragabbleImageView.transform = transform
 dragabbleImageView.longPressGesture?.addTarget(self, action: #selector(self.longpressGestureReconized))
 dragabbleImageView.pinchGesture?.addTarget(self, action: #selector(self.handlePinchGesture))
 dragabbleImageView.rotationGesture?.addTarget(self, action: #selector(self.handleRotationGesture))
 dragabbleImageView.rotationGesture?.delegate = self as? UIGestureRecognizerDelegate
 view.addSubview(dragabbleImageView as? UIView ?? UIView())
 dragabbleImageViews.append(dragabbleImageView)
 }
 
 
 }
 */
