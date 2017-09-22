//
//  registerViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/2/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let touch: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(touch)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}



func validateEmail(candidate: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
}

// Takes a string and returns True if the string only has letters, dashes, or spaces in it
func validateString(str: String, characters: String) -> Bool {
    let acceptable = "abcdefghijklmnopqrstuvwxyz" + characters
    for each in str.lowercased().characters {
        if !acceptable.characters.contains(each) {
            return false
        }
    }
    return true
}

class registerViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var fname: UITextField!
    @IBOutlet var lname: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var repassword: UITextField!
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    @IBAction func register(_ sender: Any) {
        
        if fname.text! == "" || lname.text! == "" || email.text! == "" || password.text! == "" || repassword.text! == "" {
            self.displayAlertMessage(title: "Error", message: "No Blank Fields Allowed!")
        }
        
        var valid = true
        
        
        if !validateEmail(candidate: email.text!) {
            print("email no no no")
            self.displayAlertMessage(title: "Warning", message: "Invalid Email!")
            valid = false
        }
            
            
            //fname < 20
        else if fname.text!.characters.count > 20 || fname.text!.isEmpty || !validateString(str: fname.text!, characters: "' -"){
            print("first name no no no")
            self.displayAlertMessage(title: "Warning", message: "First Name must be less than 20 characters and can not contain special characters")
            valid = false
        }
            
            //lname < 30
        else if lname.text!.characters.count > 30 || lname.text!.isEmpty || !validateString(str: lname.text!, characters: "' -"){
            print("last name no no no")
            self.displayAlertMessage(title: "Warning", message: "Last Name must be less than 30 characters and can not contain special characters")
            valid = false
        }
            
            //password 6-16
        else if password.text!.characters.count < 6 || password.text!.characters.count > 20 {
            print("password no no no")
            self.displayAlertMessage(title: "Warning", message: "Password must be between 6 and 20 characters")
            valid = false
        }
            
            // retype password
        else if repassword.text! != password.text! {
            self.displayAlertMessage(title: "Error", message: "Passwords do not match")
            valid = false
        }
        
        // salt and hash password
        let salt = generateSalt(length: 30)
        print(salt)
        print("\n\n\n\n\n")
        let hashed_password = sha256(string: (password.text! + salt))
        
        if valid == true {
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstoneregister.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(email.text!)&b=\(fname.text!)&c=\(lname.text!)&d=\(hashed_password!)&e=\(salt)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                //print("response = \(response)")
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                let found = (responseString! as String)
                
                DispatchQueue.main.async {
                    
                    if(found == "true"){
                        
                        let alertController = UIAlertController(title: "Error", message:
                            "That Email is already taken!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "toJCHouse", sender: self)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fname {
            self.lname.becomeFirstResponder()
            return true
        }
        else if textField == lname {
            self.email.becomeFirstResponder()
            return true
            
        }
        else if textField == email {
            self.password.becomeFirstResponder()
            return true
            
        }
        else if textField == password {
            self.repassword.becomeFirstResponder()
            return true
            
        }
        else {
            self.view.endEditing(true)
            return false
            
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
