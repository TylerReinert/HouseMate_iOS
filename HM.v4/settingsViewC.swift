//
//  settingsViewC.swift
//  HM.v4
//
//  Created by Tyler Reinert on 3/27/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class settingsViewC: UIViewController {
    
    // create alert message
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    
    // missing text field alert
    func missingfieldalert(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
    }
    
    
    // back button

    @IBAction func backhome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backhomesettings", sender: self)
    }
    // house name label
    @IBOutlet weak var houselabelname1: UILabel!
    
    
    //--------------LOAD HOUSE NAME TO LABEL------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to get house name
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonehome.php")! as URL)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            var json: Array<Any>!
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array
            } catch {
                print(error)
            }
            
            let houseName = (json[1]) as! String
            
            
            DispatchQueue.main.async {
                self.houselabelname1.text = houseName as String?
            }
            
        }
        task.resume()
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //------------------------CHANGE HOUSE NAME-------------------------------------------------------------------
    @IBAction func changehousename(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change House Name",
                                      message: "Enter a new house name.",
                                      preferredStyle: .alert)
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get textfield text
            let hname = alert.textFields![0]
            
            if hname.text!.isEmpty{
                self.missingfieldalert(title: "Warning", message: "Text Field Blank!")
            }
            else{
                let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonechangehousename.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(hname.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                    //update house name on settings page
                    DispatchQueue.main.async {
                        self.houselabelname1.text = hname.text as String?
                    }
                    
                }
                task.resume()
                // else statement ends
            }
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        
        // Add textfield
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .words
            textField.placeholder = "Enter new house name"
            textField.clearButtonMode = .whileEditing
            
        }
        
        
        // Add action buttons and show alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    //-----------------CHANGE ACCOUNT NAME-----------------------------------------------------------
    
    @IBAction func changename(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Account Name",
                                      message: "Change your name.",
                                      preferredStyle: .alert)
        
        // save button
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            // Get textfields text
            let fname = alert.textFields![0]
            let lname = alert.textFields![1]
            
            
            // warning if text fields are empty
            if fname.text!.isEmpty || lname.text!.isEmpty {
                self.missingfieldalert(title: "Warning", message: "Blank Text field(s)")
            }
                
            else{
                
                let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonechangeacctname.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(fname.text!)&b=\(lname.text!)"
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                }
                task.resume()
            }
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        
        // Add firstname textfield
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Enter your first name."
            textField.textColor = UIColor.black
        }
        
        
        // Add lastname textfield
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Enter your last name."
            textField.textColor = UIColor.black
        }
        
        
        
        // Add action buttons aand show alert
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    //--------------------LEAVE HOUSE-----------------------------------------------------
    
    
    @IBAction func LeaveHouse(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to leave this house?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action: UIAlertAction!) in
            
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstoneleavehouse.php")! as URL)
            request.httpMethod = "POST"
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(String(describing: error))")
                    return
                }
            }
            task.resume()
            
            self.performSegue(withIdentifier: "leavetojoin", sender: self)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //----------------------------------------DELETE ACCOUNT----------------------------------------
    
    
    @IBAction func AccountDelete(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/deleteaccount.php")! as URL)
            request.httpMethod = "POST"
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
            }
            task.resume()
            
            self.performSegue(withIdentifier: "deletetologin", sender: self)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //------------------------------LOGOUT-----------------------------------------
    
    
    
    @IBAction func logoff(_ sender: UIButton) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonelogout.php")! as URL)
        request.httpMethod = "POST"
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
        }
        task.resume()
        
        self.performSegue(withIdentifier: "settingslogout", sender: self)
        
        
    }
    
    //---------CHANGE PASS----------------------------------------------------------------------
    
    @IBAction func changepassword(_ sender: Any) {
        var status1 : Bool = false
        let alert = UIAlertController(title: "Change Your Password",
                                      message: "Enter Your Current Password",
                                      preferredStyle: .alert)
        
        // save button
        let save = UIAlertAction(title: "Enter", style: .default, handler: { (action) -> Void in
            // Get textfields text
            let current = alert.textFields![1]
            let email = alert.textFields![0]
            
            
            
            // warning if text fields are empty
            if current.text!.isEmpty || email.text!.isEmpty {
                self.missingfieldalert(title: "Warning", message: "Blank Text field(s)")
            }
                
            else{
                
                let myUrl = URL(string: "http://cgi.soic.indiana.edu/~team54/capstonelogin.php");
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "POST"// Compose a query string
                
                let postString = "a=\(email.text!)&b=\(current.text!)";
                
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
                        let hash = sha256(string: current.text! + dbsalt)
                        
                        if (dbpassword == hash) {
                            status1 = true
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        //Update UI
                        if (status1 == true){
                            var status2 : Bool = false
                            let alert = UIAlertController(title: "Change Your New Password",
                                                          message: "Re-Enter Your New Password",
                                                          preferredStyle: .alert)
                            
                            // save button
                            let save = UIAlertAction(title: "Enter", style: .default, handler: { (action) -> Void in
                                // Get textfields text
                                let pass1 = alert.textFields![1]
                                let pass2 = alert.textFields![0]
                                
                                
                                
                                // warning if text fields are empty
                                if pass1.text!.isEmpty || pass2.text!.isEmpty {
                                    self.missingfieldalert(title: "Warning", message: "Blank Text field(s)")
                                }
                                    
                                else if pass1.text!.characters.count < 6 || pass1.text!.characters.count > 20 {
                                    print("password no no no")
                                    self.displayAlertMessage(title: "Warning", message: "Password must be between 6 and 20 characters")
                                    status2 = false
                                }
                                    
                                    // retype password
                                else if pass1.text! != pass2.text! {
                                    self.displayAlertMessage(title: "Error", message: "Passwords do not match")
                                    status2 = false
                                }
                                    
                                    
                                else{
                                    
                                    // ADD PHP
                                    let myUrl = URL(string: "http://cgi.soic.indiana.edu/~team54/capstonechangeuserpassword.php");
                                    
                                    // salt and hash password
                                    let salt = generateSalt(length: 30)
                                    let hashed_password = sha256(string: (pass1.text! + salt))
                                    
                                    
                                    var request = URLRequest(url:myUrl!)
                                    
                                    request.httpMethod = "POST"// Compose a query string
                                    
                                    let postString = "a=\(hashed_password!)&b=\(salt)";
                                    
                                    request.httpBody = postString.data(using: String.Encoding.utf8);
                                    
                                    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                                        
                                        
                                        
                                        
                                        DispatchQueue.main.async {
                                            self.displayAlertMessage(title: "Success", message: "Password changed")
                                        }
                                        
                                        
                                    }
                                    
                                    task.resume()
                                }
                            })
                            
                            
                            // Cancel button
                            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
                            
                            
                            // Add email textfield
                            alert.addTextField { (textField: UITextField) in
                                textField.keyboardAppearance = .dark
                                textField.keyboardType = .default
                                textField.autocorrectionType = .default
                                textField.placeholder = "Enter Your New Password."
                                textField.isSecureTextEntry = true
                                textField.textColor = UIColor.black
                                
                                
                            }
                            
                            // add password textfield
                            alert.addTextField { (textField: UITextField) in
                                textField.keyboardAppearance = .dark
                                textField.keyboardType = .default
                                textField.placeholder = "Re-Enter Your New Password."
                                textField.isSecureTextEntry = true
                                textField.textColor = UIColor.black
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            // Add action buttons aand show alert
                            alert.addAction(save)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                            
                        }
                        else{
                            
                            self.displayAlertMessage(title: "Error", message: "Wrong Password/Email!")
                        }
                    }
                }
                
                task.resume()
            }
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        
        // Add email textfield
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter Your Email."
            textField.textColor = UIColor.black
            
            
        }
        
        // add password textfield
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.placeholder = "Enter Your Current Password"
            textField.isSecureTextEntry = true
            textField.textColor = UIColor.black
            
        }
        
        
        
        
        
        
        
        
        
        // Add action buttons aand show alert
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    //---------------------------View House Members-----------------------------------------
    
    
    
    @IBAction func viewmembers(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toviewmembers", sender: self)
        
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
