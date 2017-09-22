//
//  FinanceViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/24/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var amount: UITextField!
    @IBOutlet var pastPayments: UITableView!
    
    
    var list = [String]()
    var selection = String()
    var payments = [[String]]()
    
    func currentdate() -> String {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let datestr = dateFormatter.string(from: date as Date)
        return datestr
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func loadDebts() {
        // get finances
        let request1 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetmydebts.php")! as URL)
        
        let task1 = URLSession.shared.dataTask(with: request1 as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            var json1: Array<Any>!
            do {
                json1 = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.payments = json1 as! [[String]]
                print("\n\nWWWWWWWWWWWWWW",self.payments)
            }
            
            
        }
        task1.resume()

    }
    
    
    // when field starts to be edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -180, up: true)
        
    }
    
    // finish Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -180, up: false)
    }
    
    // Move the textfield
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    
    // swipe left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeletemydebts.php")! as URL)
        request.httpMethod = "POST"
        print(payments)
        let postString = "a=\(payments[indexPath.row][1])"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let asset_owner = (responseString! as String)
            print("\n\n\nWEWRRAGAGRSFG", asset_owner)
            
            if asset_owner.characters[asset_owner.characters.startIndex] == "y" {
                let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this debt?", preferredStyle: UIAlertControllerStyle.alert)
            
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                    
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeletedebt.php")! as URL)
                    request.httpMethod = "POST"
                    
                    let postString = "a=\(self.payments[indexPath.row][2])"
                    
                    request.httpBody = postString.data(using: String.Encoding.utf8)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
                        if error != nil {
                            print("error=\(error)")
                            return
                        }
                    }
                    task.resume()
                    self.payments.remove(at: indexPath.row)
                    self.pastPayments.reloadData()
                    

                    
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.displayAlertMessage(title: "Error", message: "You can't delete this debt because you are being charged in this transaction.")
            }
            
            
            
        }
        task.resume()
        
        
        }
        }
    
    
    
    
    
    override func viewDidLoad() {
        self.hideKeyboard()
        super.viewDidLoad()
        
        self.pastPayments.separatorStyle = UITableViewCellSeparatorStyle.none
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        // get roommates
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetroommates.php")! as URL)
        
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
            self.list = json as! [String]
            
        }
        task.resume()
        
        loadDebts()
        
        self.pastPayments.estimatedRowHeight = 80
        self.pastPayments.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pastPayments.reloadData()
    }
    
    @IBAction func showMembers(_ sender: Any) {
        self.pickerView.reloadAllComponents()
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.textColor = .darkGray
        pickerLabel.textAlignment = .center
        pickerLabel.text = self.list[row]
        pickerLabel.font = UIFont(name:"Helvetica", size: 16)
        
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = list[row]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = payments[indexPath.row][0]
        cell.textLabel?.font = UIFont(name:"Avenir", size:16)
        cell.textLabel?.numberOfLines=0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return(cell)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(payments.count)
    }
    
    func validateNumber(str: String) -> Bool {
        let acceptable = "1234567890."
        for each in str.lowercased().characters {
            if !acceptable.characters.contains(each) {
                return false
            }
        }
        return true
    }
    
    @IBAction func pay(_ sender: Any) {
        //self.result.text = selection + " was paid $" + self.amount.text! + "!"
        
        if self.amount.text!.isEmpty {
            self.displayAlertMessage(title: "Error", message: "Amount can not be empty")
        }
        else if !validateNumber(str: self.amount.text!) {
            self.displayAlertMessage(title: "Error", message: "Amount can only be a number")
        }
        else if selection == ""{
            self.displayAlertMessage(title: "Error", message: "You have to select a roommate first!")
        }
        else {
        
            let debt = " requested $" + self.amount.text! + " from " + selection + " on " + currentdate()
            
            // you requested
            payments.insert([("You" + debt)], at: 0)
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreatedebt.php")! as URL)
            request.httpMethod = "POST"
            let postString = "a=\(debt)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)

            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                

                
            }
            task.resume()
            //loadDebts()
            pastPayments.reloadData()
            //self.performSegue(withIdentifier: "payToHome", sender: self)
            self.displayAlertMessage(title: "Success", message: "Your Request Was Sent!")

        }
        self.amount.text! = ""
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
