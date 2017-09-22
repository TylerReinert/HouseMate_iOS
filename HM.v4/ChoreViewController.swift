//
//  ChoreViewController.swift
//  HouseMate
//
//  Created by Sean Davis on 2/2/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

var choreList = [[String]]()


class ChoreViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    @IBOutlet weak var choreTableView: UITableView!
    
    
    // 'Add New Chore' button
    @IBAction func addNewChore(_ sender: Any) {
        let alert = UIAlertController(title:"New Chore", message: nil, preferredStyle:UIAlertControllerStyle.alert)
        
        // text field
        alert.addTextField { (UITextField) in
        }
        
        // 'Add' button
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            (action) -> Void in
            
            // assigns text field entry to newChore
            let newChore = alert.textFields![0] as UITextField
            
            // check to make sure entry is acceptable (not done yet)
            if !validateString(str: newChore.text!, characters: "1234567890'- ") || newChore.text!.isEmpty {
                self.displayAlertMessage(title: "Error", message: "Invalid Entry")
            }
                
            else {
                // adds newChore to choreList
                choreList.append([newChore.text!,  "unchecked"])
                
                let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonechores.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(newChore.text!)"
                
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
                    
                    choreList = json as! [[String]]
                    
                    //print("response = \(response)")
                    
                }
                task.resume()
                
                self.choreTableView.reloadData()
            }
            
            
            
            
        }))
        
        // 'Cancel' button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) -> Void in
            
            //self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated:true, completion:nil);
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(choreList.count)
    }
    
    
    // 3 functions below added by command clicking UITableViewDataSource above
    
    // adds choreList to tableview
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = choreList[indexPath.row][0]
        cell.selectionStyle = UITableViewCellSelectionStyle.gray
        cell.textLabel?.numberOfLines=0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // adds checkmark to cells that should have it
        if choreList[indexPath.row][1] == "checked"
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        
        return(cell)
    }
    
    // swipe left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeletechores.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(choreList[indexPath.row][2])"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                
            }
            task.resume()
            choreList.remove(at: indexPath.row)
            choreTableView.reloadData()
        }
        
    }
    
    // changes an item's checked status when its cell is touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var status = ""
        
        if choreList[indexPath.row][1] == "unchecked"
        {
            choreList[indexPath.row][1] = "checked"
            status = "checked"
            
        }
        else
        {
            choreList[indexPath.row][1] = "unchecked"
            status = "unchecked"
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonechoresstatus.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(status)&b=\(choreList[indexPath.row][2])"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            
        }
        task.resume()
        
        choreTableView.reloadData()
        
        
    }
    
    // enables 'Edit' button at top right of screen
    // might need navigation controller to work
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.choreTableView.setEditing(editing, animated: animated)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        choreTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 'Edit' button at top right of screen
        navigationItem.rightBarButtonItem = editButtonItem
        
        let request2 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetchores.php")! as URL)
        
        let task2 = URLSession.shared.dataTask(with: request2 as URLRequest) {
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
            
            choreList = json as! [[String]]
            
            
        }
        task2.resume()
        
        self.choreTableView.reloadData()
        
        
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
