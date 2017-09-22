//
//  CreateAssetViewController.swift
//  HM.v4
//
//  Created by Sean Davis on 3/22/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit
import Photos



class CreateAssetViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
  
    var filename = String()
    // to create unique file name
    let rand = generateSalt(length: 10)
   

    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == assetName {
            self.assetDescription.becomeFirstResponder()
            return true
        }
        else {
            self.view.endEditing(true)
            return false
            
        }
        
    }
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
    }
    
    // filename variable
    var photofilename =  ""
    
    
    // name
    @IBOutlet weak var assetName: UITextField!
    
    // description
    @IBOutlet weak var assetDescription: UITextField!
    
    
    
    
    
    
    // image view to upload photo
    @IBOutlet weak var importImage: UIImageView!
    
    
    
    
    
    
    
    
    
    
    
    
    // Select picture from user's photo library
    @IBAction func fromlibrary(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        // sets source of image from photo library
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        
    }
    
    
 
    
    // when field starts to be edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -180, up: true)
        
    }
    
    // finish Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -180, up: false)
    }
    
    // Move the textfield when keyboard present
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    

    
    // after user selects image and display picture from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            importImage.image = image
          
            
        }
        
        
        // get file name of photo
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL{
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            filename = asset?.value(forKey: "filename") as! String
            self.photofilename = filename as String
            //print(asset?.value(forKey: "filename") as! String)
            print("Filename \n")
            print(filename)
            print("variable filename: \n")
            print(photofilename)
        }
            
        else {
            //Error message if nothing is selected
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // add asset to database
    @IBAction func createAsset(_ sender: UIButton) {
        
        
        // check text fields for valid input
        print(assetName.text!)
        print(assetDescription.text!)
        print()
        
        // check file type and if asset name field is blank (upload criteria)
        
        if filename.lowercased().range(of:".jpg") != nil && assetName.text!.isEmpty == false{
            print("it is a jpg")
            // lock create button while uploading
            sender.isEnabled = false
            var postString = String()
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreateassets.php")! as URL)
            request.httpMethod = "POST"
            
            if filename.isEmpty {
                postString = "a=\(assetName.text!)&b=\(assetDescription.text!)"
            }
            else{
                postString = "a=\(assetName.text!)&b=\(assetDescription.text!)&c=\(rand + filename)"
            }
            
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
            }
            
            task.resume()
            ImageUpload()
            
            // display warning messages if upload criteria doesn't fit
        }
        else if assetName.text!.isEmpty{
            self.displayAlertMessage(title: "Error", message: "Asset name can't be empty")
        }
        
        else if filename.lowercased().range(of:".jpg") == nil{
            self.displayAlertMessage(title: "Error", message: "You Can Only Upload Images with File Type .jpg!")
        }

      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
    
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------ FUNCTION THAT SENDS TO PHP--------------------------------
    func ImageUpload()
    {
        if !filename.isEmpty {
            
            // set text fields to variables for parameters
            let asstdesc: String = assetDescription.text!
            let asstname: String = assetName.text!
            
            let myUrl = NSURL(string: "http://cgi.soic.indiana.edu/~team54/uploadassetsimage.php");
            
            
            let request = NSMutableURLRequest(url:myUrl! as URL);
            request.httpMethod = "POST";
            // set parameters
            let param = [
                "AssetName"  : asstname,
                "Description"    : asstdesc,
                ]
            
            let boundary = generateBoundaryString()
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // set data to be uploaded to UI photo view
            let imageData = UIImageJPEGRepresentation(importImage.image!, 0.2)
            
            if(imageData==nil)  { return; }
            
            request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
            
            
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                // You can print out response object
                print("******* response = \(response)")
                
                // Print out reponse body
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    print(json)
                    //reset testfield and go back to view assets
                    DispatchQueue.main.async(execute: {
                        self.assetName.text! = ""
                        self.assetDescription.text = ""
                        self.importImage.image = nil;
                        self.performSegue(withIdentifier: "createassetback", sender: self)
                    });
                    
                }catch
                {
                    print(error)
                }
                
                
            }
            
            task.resume()
        }
        
    }
    
    
    //function to create parameters
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        //set filename to file name from users phone
        
        filename = (rand + photofilename) as String
        let mimetype = "image/jpg"
        print("filename:")
        print(filename)
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
}


//for file encoding name
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
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
