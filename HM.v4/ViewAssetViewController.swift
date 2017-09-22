//
//  ViewAssetViewController.swift
//  HM.v4
//
//  Created by Sean Davis on 3/22/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class ViewAssetViewController: UIViewController {
    
    var path = String()
    
    
    @IBOutlet weak var spin: UIActivityIndicatorView!
    
    
    
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    
    var assetID = String()
    var assetDetails = [String]()
    var owner = String()
    
    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var assetDescription: UILabel!
    @IBOutlet weak var assetOwner: UILabel!
    
    
    
    
    
    
    
    @IBAction func deleteAsset(_ sender: Any) {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeleteasset.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(owner)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let asset_owner = (responseString! as String)
            
            if asset_owner.characters[asset_owner.characters.startIndex] == "y" {
                let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this asset?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeleteassets.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.assetID)"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
                        if error != nil {
                            print("error=\(error)")
                            return
                        }
                    }
                    task.resume()
                    
                    self.performSegue(withIdentifier: "deleteBack", sender: self)
                    
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.displayAlertMessage(title: "Error", message: "You can not delete this asset because you do not own it.")
            }
            
            
            
        }
        task.resume()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get asset from database
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstoneloadasset.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(assetID)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var json: Array<Any>!
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array
            } catch {
                print(error)
            }
            
            
            DispatchQueue.main.async {
                self.assetDetails = json as! [String]
                self.assetName.text! = self.assetDetails[0]
                self.assetDescription.text! = self.assetDetails[1]
                self.assetOwner.text! = self.assetDetails[3] + " " + self.assetDetails[4]
                self.owner = self.assetDetails[2]
                self.path = self.assetDetails[5]
                print("\n\n\n\nPATH")
                print("http://cgi.soic.indiana.edu/~team54/images/" + self.path)
                //---------LOAD ASSET IMAGE------------------------------------
                    if !self.path.isEmpty {
                        let imageUrlString = "http://cgi.soic.indiana.edu/~team54/images/" + self.path
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        // Start background thread so that image loading does not make app unresponsive
                        DispatchQueue.global(qos: .userInitiated).async {
                            // create imageview for asset image
                            let imageData:NSData = NSData(contentsOf: imageUrl)!
                            let imageView = UIImageView(frame: CGRect(x:39, y:109, width:300, height:250))
                            
                            
                            // update UI with image after image view is created
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData as Data)
                                imageView.image = image
                                imageView.contentMode = UIViewContentMode.scaleAspectFit
                                self.view.addSubview(imageView)
                                print("\n\n")
                                // stop activity indicator
                                self.spin.stopAnimating()
                                print("image loaded")
                            }
                        }
                    }
                

                
            }
            
            
            
            
            
            
            
        }
        task.resume()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
