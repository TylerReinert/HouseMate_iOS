//

//  ViewController.swift

//  simpleChat

//

//  Created by Roberto Konanz on 4/4/17.

//  Copyright © 2017 Roberto Konanz. All rights reserved.

//



import UIKit



var items = [[String]]()

class ChatViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate{
    
    
    
    
    
    //back to home button
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "messagehome", sender: self)
    }
    
    
    // warning message func
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
    }

    
    
    @IBAction func refresh(_ sender: Any) {
        // load messages of house
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetmessages.php")! as URL)
        
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
                print("here")
                print(json)
                items = json as! [[String]]
                self.messageBoard.reloadData()
                // self.messageBoard.scrollToRow(at: json.last! as! IndexPath, at: .bottom, animated: true)
            }
            
            
        }
        task.resume()
        
        tableViewScrollToBottom(animated: false)
        
    
    }


    
    
    @IBOutlet var messageBoard: UITableView!
    
    @IBOutlet var messageText: UITextField!
    
    
    
    
    
    // when field starts to be edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -218, up: true)
    }
    
    // finish Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -218, up: false)
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
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboard()
        self.messageBoard.separatorStyle = UITableViewCellSeparatorStyle.none
        self.messageText.delegate = self;
        
        // load messages of house
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetmessages.php")! as URL)
        
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
                print(json)
                items = json as! [[String]]
                self.messageBoard.reloadData()
                // self.messageBoard.scrollToRow(at: json.last! as! IndexPath, at: .bottom, animated: true)
            }
            
            
        }
        task.resume()
        
        tableViewScrollToBottom(animated: false)
 
    }
    
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.messageBoard.numberOfSections
            let numberOfRows = self.messageBoard.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.messageBoard.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        
        
        
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func send(_ sender: UIButton) {
    
        // check if message is empty
        if messageText.text! == ""{
            self.displayAlertMessage(title: "Error", message: "Cannot Send Empty Message!")
        }
        else if messageText.text!.characters.count > 250 {
            self.displayAlertMessage(title: "Error", message: "Message can only be 250 characters")
            
        }
        else{
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreatemessage.php")! as URL)
            request.httpMethod = "POST"
        
            let postString = "a=\(messageText.text!)"
        
            request.httpBody = postString.data(using: String.Encoding.utf8)
        
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
            
                if error != nil {
                    print("error=\(error)")
                    return
                }
        
        
            }
            task.resume()
            items.append([messageText.text!, "You"])
        }
        //clear send text field
        self.messageText.text = ""
        // reload tableview data
        self.messageBoard.reloadData()
        tableViewScrollToBottom(animated: false)
    
        
    }



    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        textField.resignFirstResponder()

        
        return false
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        
        return(items.count)
        
    }
    

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = items[indexPath.row][1]
        cell.textLabel?.font = UIFont(name:"Avenir", size:11)
        cell.textLabel?.textColor = UIColor.blue
        cell.detailTextLabel?.text = items[indexPath.row][0]
        cell.detailTextLabel?.font = UIFont(name:"Avenir", size:16)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.detailTextLabel?.numberOfLines=0 // line wrap
        cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        return(cell)
        
    }
    
    
}



    
    
    

