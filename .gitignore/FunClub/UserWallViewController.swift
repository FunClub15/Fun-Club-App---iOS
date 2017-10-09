//
//  UserWallViewController.swift
//  FunClub
//
//  Created by NISUM on 9/19/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit

class UserWallViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    
    var canHideFullScreenOverlay:Bool = false
    var overlay : UIView? //loading overlay
    var delegate: HomeDelegate?
    let navigationHelper = NavigationHelper()
    var imagePicker = UIImagePickerController()

    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var statusTxtView: UITextView!

    @IBOutlet weak var userNameLbl: UILabel!
    var base64String = ""
    var images = [Any]()
    var dragabbleImageViews = [Any]()
    var selectedImageIndex: Int = 0
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userID: String = "0"
    
    var dashBoardStickersDataArr : [Data] = []
    var dashBoardStickersIdArr : [String] = []
    
    var dashboardImages : [UserDashboardImages] = []
    
    var imgCount : Int = 0
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    @IBOutlet weak var preview: UIView!
    var cameraType = 0
    var videoURL: URL?
    var movieData:Data?

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
        
        imagePicker.delegate = self
        
    }
    
       
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        return
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.overlay!.frame = CGRect(x:0,y:0, width:600, height:800)//self.view.frame
        
        setProfile()
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        saveImages()
    }
    
    func setProfile(){
        let defaults = UserDefaults.standard
        var picUrl = defaults.value(forKey: "pic") as! String
        let type = defaults.value(forKey: "typeLogin") as! String
        
        if type == "FB" {
            picUrl = defaults.value(forKey: "picFB") as! String
        }
        let userName = defaults.value(forKey: "userName") as! String
        userNameLbl.text = userName
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
    
    func showLoader(show:Bool){
        Loading.sharedInstance.showLoader(show: show, view:self.view, overlay:self.overlay! )
        // Loading.sharedInstance.disableLinks( nc: self.navigationController!, enable:(!show) )
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
    
    @IBAction func uploadPhoto(_ sender: Any) {
        cameraType = 0
        statusTxtView.resignFirstResponder()

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
        
        if cameraType == 1 {
      
            videoURL = info[UIImagePickerControllerMediaURL] as? URL
            print("videoURL:\(String(describing: videoURL))")
            
            do{
                //             movieData =  try Data.init(contentsOf: self.filePathArray[index] as! URL, options: .alwaysMapped)
                
                movieData = try Data.init(contentsOf: videoURL!)
                
                
            }catch{
                
            }
            
            
//            var encoder = SDAVAssetExportSession(asset: AVAsset(url: info[UIImagePickerControllerMediaURL]!))
//            var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//            var documentsDirectory: String = paths[0]
//            myPathDocs = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("lowerBitRate-\(arc4random() % 1000).mov").absoluteString
//            var url = URL.fileURL(withPath: myPathDocs)
//            encoder.outputURL = url
//            encoder.outputFileType = .mp4
//            encoder.shouldOptimizeForNetworkUse = true
//            encoder.videoSettings = [AVVideoCodecKey: AVVideoCodecH264, AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: 2300000, // Lower bit rate here
//                AVVideoProfileLevelKey: AVVideoProfileLevelH264High40]]
//            encoder.audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100, AVEncoderBitRateKey: 128000]
//            
//            encoder.exportAsynchronously(completionHandler: {() -> Void in
//                var status: Int = encoder.status
//                if status == .completed {
//                    var videoTrack: AVAssetTrack? = nil
//                    var asset = AVAsset(url: (encoder.outputURL)!) as? AVURLAsset
//                    var videoTracks = asset.tracks(withMediaType: .video)
//                    videoTrack = videoTracks[0]
//                    var frameRate: Float? = videoTrack?.nominalFrameRate
//                    var bps: Float? = videoTrack?.estimatedDataRate
//                    print("Frame rate == \(frameRate)")
//                    print("bps rate == \(bps / (1024.0 * 1024.0))")
//                    print("Video export succeeded")
//                    // encoder.outputURL <- this is what you want!!
//                }
//                else if status == .cancelled {
//                    print("Video export cancelled")
//                }
//                else {
//                    print("Video export failed with error: \(encoder.error.localizedDescription) (\(encoder.error.code))")
//                }
//                
//            })
            
            

        }
        else {
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            uploadImage.contentMode = .scaleAspectFit //3
            uploadImage.image = nil
            uploadImage.image = chosenImage
            img.image = chosenImage //4
            base64String = ""
            //
            
            if let imageData = img.image?.jpeg(.lowest) {
                print(imageData.count)
                base64String = imageData.base64EncodedString()
                
                
            }
        
        }
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func uploadVideo(_ sender: Any) {
        cameraType = 1
        statusTxtView.resignFirstResponder()

        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openVDOCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openVDOGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
  /*
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = true
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
//            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
//            imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .camera
//            imagePicker.mediaTypes = NSArray(object: kUTTypeMovie)  as! [String]
//
//            imagePicker.showsCameraControls = true
//            imagePicker.allowsEditing = true
//
//
//            self.showImagePickerController(sourceType: .camera)

//            self.present(imagePicker, animated: true, completion: nil)
//            
//            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//            
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//                captureSession = AVCaptureSession()
//                captureSession?.canAddInput(input)
//            } catch {
//                print(error)
//            }
//          
//            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//            videoPreviewLayer?.frame = view.layer.bounds
//            preview.layer.addSublayer(videoPreviewLayer!)
//            
//            captureSession?.startRunning()
            
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                
//                imagePicker.showsCameraControls = false
                
//                imagePicker.modalPresentationStyle = .custom
                self.present(self.imagePicker, animated: true, completion: nil)
            }

        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
*/

    }
    
    func openVDOCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.showsCameraControls = true

            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openVDOGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        
        
        //                imagePicker.modalPresentationStyle = .custom

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func vdoUpload(){
        self.showLoader(show: true)
        let myUrl = NSURL(string: Constants.postStatusURL);
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        let defaults = UserDefaults.standard
        let userID = defaults.value(forKey: "userId") as! String

         let parameters = ["member_id":userID, "picture": base64String, "post_description":statusTxtView.text!] as [String : Any]
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
//        let imageData = UIImageJPEGRepresentation(profileImgView.image!, 1)
        
//        if(imageData==nil)  { return; }
        
//        var movieData:Data?
        do{
//             movieData =  try Data.init(contentsOf: self.filePathArray[index] as! URL, options: .alwaysMapped)
            
            movieData = try Data.init(contentsOf: videoURL!)
            
            
        }catch{
            
        }

        request.httpBody = createBodyWithParameters(parameters: parameters as? [String : String], filePathKey: "video", imageDataKey: movieData! as NSData, boundary: boundary) as Data
        
        
        
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
                
                if msg == "Successfully Inserted" {
                    UIUtility.sharedInstance.showAlert(title: Constants.Alert, message:"You have successfully register. To enjoy FunClub please verify the verification email.", btnTitle:Constants.CLOSE)
                    
                    self.navigationController!.popToRootViewController(animated: true)
                    
                    
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
        
        let filename = "user-video.mov"
        let mimetype = "video/mov"
        
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


    @IBAction func goLive(_ sender: Any) {
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        
        
        self.present(imagePicker, animated: true, completion: nil)
        
        imagePicker.startVideoCapture()

    }
    
    @IBAction func postStatus(_ sender: Any) {
//        if cameraType == 1 {
//        vdoUpload()
//        }
//        else {
        showLoader(show: true)
        statusTxtView.resignFirstResponder()
        let api = API()
        let defaults = UserDefaults.standard
        let userID = defaults.value(forKey: "userId") as! String
        let parameters = ["member_id":userID, "picture": base64String, "post_description":statusTxtView.text!, "video": movieData as Any] as [String : Any]
        
        api.postStatus(parameters: parameters as AnyObject, callback: statusPost)
//        }
    }
    func statusPost(_ message:String, _ status:String){
        showLoader(show: false)

    }
}
