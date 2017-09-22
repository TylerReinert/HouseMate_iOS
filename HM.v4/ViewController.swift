//
//  ViewController.swift
//  HM.v4
//
//  Created by Ben Myatt on 2/24/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

var status : Bool = false

func sha256(string: String) -> String? {
    guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
    var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    
    let shaHex =  digestData.map { String(format: "%02hhx", $0) }.joined()
    
    return shaHex
}


func generateSalt(length: Int) -> String {
    
    let characters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)"
    let len = UInt32(characters.length)
    
    var salt = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = characters.character(at: Int(rand))
        salt += NSString(characters: &nextChar, length: 1) as String
    }
    
    return salt
}


class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    
    @IBAction func login(_ sender: Any) {
        
        if email.text! == "" || password.text! == "" {
            self.displayAlertMessage(title: "Error", message: "No Blank Fields Allowed!")
            return
        }
        
        let myUrl = URL(string: "http://cgi.soic.indiana.edu/~team54/capstonelogin.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "a=\(email.text!)&b=\(password.text!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            var json: Array<Any>!
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array
            } catch {
                print(error)
            }
            let count = json.count
                
            if count < 1 || count > 1{
                
                let dbpassword = (json[0]) as! String
                let dbsalt = (json[1]) as! String
                let hash = sha256(string: self.password.text! + dbsalt)
                
                if (dbpassword == hash) {
                    status = true
                }
                
            }
            
            DispatchQueue.main.async {
                //Update your UI here
                if (status == true){
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                    status = false
                }
                else{
                    
                    self.displayAlertMessage(title: "Error", message: "Wrong User/Password")
                }
            }
        }
        
        task.resume()
    
    
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        email.delegate = self
        password.delegate = self
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.becomeFirstResponder()
        password.becomeFirstResponder()
        
        if(textField == password)
        {
            textField.resignFirstResponder()
            
        }
        return false
    }
    
    //called when text field is tapped on
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        if(email.layer.position.y > 65){
            scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
            
            
        
        }
        if(password.layer.position.y > 0){
            scrollView.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
            
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }*/
    
    
    

}

