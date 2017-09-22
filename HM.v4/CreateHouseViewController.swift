//
//  CreateHouseViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/2/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class CreateHouseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var houseName: UITextField!
    @IBOutlet var houseUsername: UITextField!
    @IBOutlet var housePassword: UITextField!
    @IBOutlet var retypePassword: UITextField!
    
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    @IBAction func createHouse(_ sender: Any) {
        
        if houseName.text == "" || housePassword.text == ""{
            self.displayAlertMessage(title: "Error", message: "No Blank Fields Allowed!")
        }
        
        if !validateString(str: housePassword.text!, characters: " 0123456789'-()"){
            self.displayAlertMessage(title: "Error", message: "House Password Can Only Contain Letters and Dashes!")
        }
        
        
        let salt = generateSalt(length: 30)
        print(salt)
        print("\n\n\n\n\n")
        let hashed_password = sha256(string: (housePassword.text! + salt))
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreatehouse.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(hashed_password!)&b=\(salt)&c=\(houseName.text!)&d=\(houseUsername.text!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
            
            
        }
        task.resume()
        
        
        
    
    
    
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
    

    // to allow next and done buttons on keyboard to work
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == houseName {
            self.houseUsername.becomeFirstResponder()
            return true
        }
        else if textField == houseUsername {
            self.housePassword.becomeFirstResponder()
            return true
            
        }
        else if textField == housePassword {
            self.retypePassword.becomeFirstResponder()
            return true
            
        }
        
        else {
            self.view.endEditing(true)
            return false
            
        }
        
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
