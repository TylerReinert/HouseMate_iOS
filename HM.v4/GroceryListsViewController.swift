//
//  GroceryViewController.swift
//  HouseMate
//
//  Created by Sean Davis on 2/2/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

var groceryLists = [[String]]()
var dbGroceryItems = [[String]]()
var dbGroceryListID = String()


class GroceryListsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    @IBOutlet weak var groceryListsTableView: UITableView!
    
    
    // 'Add New Item' button
    
    @IBAction func createNewList(_ sender: Any) {
        let alert = UIAlertController(title:"New Grocery List", message: nil, preferredStyle:UIAlertControllerStyle.alert)
        
        // text field
        alert.addTextField { (UITextField) in
        }
        
        // 'Add' button
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            (action) -> Void in
            
            // assigns text field entry to newItem
            let newGroceryList = alert.textFields![0] as UITextField
            
            // check to make sure entry is acceptable
            // need to make number acceptable
            if  newGroceryList.text!.isEmpty {
                self.displayAlertMessage(title: "Error", message: "No Blank Fields Allowed!")
            }
                
            else {
                // adds newGroceryList to groceryLists
                groceryLists.append([newGroceryList.text!])
                
                let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreateglists.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(newGroceryList.text!)"
                
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
                    
                    groceryLists = json as! [[String]]
                    
                    
                }
                task.resume()
                
                self.groceryListsTableView.reloadData()
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
        return(groceryLists.count)
    }
    
    
    // 3 functions below added by command clicking UITableViewDataSource above
    
    // adds groceryList to tableview
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = groceryLists[indexPath.row][0]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.selectionStyle = UITableViewCellSelectionStyle.gray
        cell.textLabel?.numberOfLines=0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return(cell)
    }
    
    //  swipe left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeleteglists.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(groceryLists[indexPath.row][1])"
            
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                
            }
            task.resume()
            groceryLists.remove(at: indexPath.row)
            groceryListsTableView.reloadData()
        }
    }
    
    // select item from list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get list from database
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetgitems.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(groceryLists[indexPath.row][1])"
        dbGroceryListID = groceryLists[indexPath.row][1]
        
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
            dbGroceryItems = json as! [[String]]
            
            
            
        }
        task.resume()
        
        usleep(500000)
        
        self.performSegue(withIdentifier: "grocerySegue", sender: self)
        
        
    }
    
    // enables 'Edit' button at top right of screen
    // might need navigation controller to work
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.groceryListsTableView.setEditing(editing, animated: animated)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        groceryListsTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 'Edit' button at top right of screen
        let request2 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetglists.php")! as URL)
        
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
            
            groceryLists = json as! [[String]]
        }
        task2.resume()
        self.groceryListsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "grocerySegue" {

            let GroceryViewController:GroceryViewController = segue.destination as! GroceryViewController;
            GroceryViewController.groceryItems = dbGroceryItems
            GroceryViewController.groceryListID = dbGroceryListID
         

     }
    
    }
}
