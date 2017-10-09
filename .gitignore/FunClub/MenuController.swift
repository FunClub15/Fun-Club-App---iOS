//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    @IBOutlet weak var profileImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: UIButton){
        let defaults = UserDefaults.standard
        defaults.set("N", forKey: "isLogin")
        defaults.synchronize()
        
    }
    override func viewWillAppear(_ animated: Bool) {
     
        let defaults = UserDefaults.standard
        var picUrl = defaults.value(forKey: "pic") as! String
        let type = defaults.value(forKey: "typeLogin") as! String

        if type == "FB" {
            picUrl = defaults.value(forKey: "picFB") as! String
        }
                

        print(picUrl)
        self.profileImgView.image = nil
//        self.profileImgView.layoutSubviews()
        
        if picUrl != "0" {
            let image_url:NSURL = NSURL(string: picUrl)!
            let url_request = NSURLRequest(url: image_url as URL)
            let placeholder = UIImage(named: "images_not_found_1.png")
            
            
//            profileImgView.downloadedFrom(link: picUrl)
//            self.profileImgView.layer.cornerRadius = (self.profileImgView.frame.size.width) / 2;
//            self.profileImgView.clipsToBounds = true;

            //Load image asynchronously
            self.profileImgView.setImageWith(url_request as URLRequest, placeholderImage: placeholder,
                                             success: { [weak self] (request:URLRequest,response:HTTPURLResponse?, image:UIImage) -> Void in
                                                self?.profileImgView.image = nil

                                                self?.profileImgView.layer.cornerRadius = (self?.profileImgView.frame.size.width)! / 2;
                                                self?.profileImgView.clipsToBounds = true;
                                                self!.profileImgView.image = image
                                                self?.profileImgView.layoutSubviews()
                                                

                                                //                                        UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
                }, failure: { [weak self] (request:URLRequest,response:HTTPURLResponse?, error:Error) -> Void in
                    //                UIUtility.sharedInstance.startRemoveActivityIndicator(start: false,aIndicator:self!.imageSpinner)
            })
        }
 
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleToFill) {
        contentMode = mode
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
