//
//  JoinHouseViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/4/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

var housestatus : Bool = false

class JoinHouseViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    @IBOutlet var houseUsername: UITextField!
    @IBOutlet var housePassword: UITextField!
    
    @IBAction func joinHouse(_ sender: Any) {
        
        if houseUsername.text!.isEmpty || housePassword.text!.isEmpty {
            displayAlertMessage(title: "Error", message: "No blank fields allowed!")
        }
        
        else {
    
        let myUrl = URL(string: "http://cgi.soic.indiana.edu/~team54/capstonejoinhouse.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "a=\(houseUsername.text!)&b=\(housePassword.text!)";
        
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
                let hash = sha256(string: self.housePassword.text! + dbsalt)
                
                print("\n\n\n")
                print(dbpassword)
                print(hash!)
                print("\n\n\n")
                
                if (dbpassword == hash!) {
                    housestatus = true
                }
                
            }
            
            DispatchQueue.main.async {
                //Update your UI here
                if (housestatus == true){
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
                else{
                    self.displayAlertMessage(title: "Error", message: "Wrong House User/House Password")
                }
            }
        }
        
        task.resume()
    
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        houseUsername.delegate = self
        housePassword.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        houseUsername.becomeFirstResponder()
        housePassword.becomeFirstResponder()
        
        if(textField == housePassword)
        {
            textField.resignFirstResponder()
            
        }
        
        return false
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
