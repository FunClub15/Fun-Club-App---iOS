//
//  InteriorDesignSelectionViewController.swift
//  FunClub
//
//  Created by NISUM on 7/12/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit

class InteriorDesignSelectionViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var interiorDesignArr = Array<InteriorDesignTatto>()
    var imageArr = ["icon_fb","google_icon","icon_tw","icon_gplus"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white

        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interiorDesignArr.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! InteriorDesignSelectionCollectionViewCell
        
//        cell.imageView.image = UIImage(named: imageArr[indexPath.row])
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        cell.myLabel.text = self.items[indexPath.item]
        cell.mapDataOnView(interiorDesign: interiorDesignArr[indexPath.row])
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
//        let context =  appDelegate.moc//
//            let dashboardImages = User(context: context)
//        let imageName = interiorDesignArr[indexPath.row].image
//            _ = dashboardImages.create(imageName: imageName)

        downloadImage(url: interiorDesignArr[indexPath.row].image)

        
        
        
//        var base64String = ""
//        
//        if let imageData = profileImgView.image?.jpeg(.lowest) {
//            print(imageData.count)
//            base64String = imageData.base64EncodedString()
//            
//            
//        }
        print("You selected cell #\(indexPath.item)!")
    }
    
    func downloadImage(url: String){
        
        let newUrl = url.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let uRl = URL(string: newUrl)

        let request = URLRequest(url: uRl!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let _ = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                
//                let context =  self.appDelegate.moc
                
//                let dashboardImages = User(context: context)
//                _ = dashboardImages.createImageData(imageData: data)
                
                DispatchQueue.global().async() {
                    print("Work Dispatched")
                    // Do heavy or time consuming work
                    
                    // Then return the work on the main thread and update the UI
                    // Create a weak reference to prevent retain cycle and get nil if self is released before run finishes
                    DispatchQueue.main.async() {
                        [weak self] in
                        // Return data and update on the main thread, all UI calls should be on the main thread
                        // you could also just use self?.method() if not referring to self in method calls.
                        if self != nil {
                            let api = API()
                            var base64String = ""
                            let defaults = UserDefaults.standard
                            let userID = defaults.value(forKey: "userId") as! String
//
                            base64String = data.base64EncodedString()
                            let parameters = ["member_id":userID, "picture": base64String]
                            
                            defaults.set(base64String, forKey: "Base64")
                            defaults.synchronize()
                            let defaultFrame = CGRect(x: 100, y: 100, width: 100, height: 100)
                            let transform = CGAffineTransform.identity
                            var _: [AnyHashable: Any] = ["image": base64String, "frame": NSStringFromCGRect(defaultFrame), "transform": NSStringFromCGAffineTransform(transform)]
                            
                            api.interiorDesignStickerUpload(parameters: parameters as AnyObject)
                        }
                    }
                }
                

                
            }
            }.resume()

    
    
    }
}
