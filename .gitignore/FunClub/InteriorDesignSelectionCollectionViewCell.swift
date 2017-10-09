
//
//  InteriorDesignSelectionCollectionViewCell.swift
//  FunClub
//
//  Created by NISUM on 7/12/17.
//  Copyright © 2017 Technology-minds. All rights reserved.
//

import UIKit

class InteriorDesignSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    
    func mapDataOnView(interiorDesign: InteriorDesignTatto){
        //imageView.downloadedFrom(link: interiorDesign.image)
        print(interiorDesign.image)
        let imageUrl = interiorDesign.image 
//        let image_url:NSURL = NSURL(string: imageUrl)!
        let newString = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let image_url:NSURL = (NSURL(string: newString))!
            let url_request = NSURLRequest(url: image_url as URL)
            let placeholder = UIImage(named: "images_not_found_1.png")
        
//        imageView.image = UIImage(named:)
            
//            profileImgView.downloadedFrom(link: picUrl)
            self.imageView.layer.cornerRadius = (self.imageView.frame.size.width) / 2;
            self.imageView.clipsToBounds = true;
        
//            self.im.image = nil
                        self.imageView.setImageWith(url_request as URLRequest, placeholderImage: placeholder,
                                                         success: { [weak self] (request:URLRequest,response:HTTPURLResponse?, image:UIImage) -> Void in
                                                           
                                                            self?.imageView.clipsToBounds = true;
                                                            self!.imageView.image = image
                                                            //                                        UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
                            }, failure: { [weak self] (request:URLRequest,response:HTTPURLResponse?, error:Error) -> Void in
                                //                UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
                        })
        }
    
}
