//
//  GroceryViewController.swift
//  HouseMate
//
//  Created by Sean Davis on 2/2/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

//var groceryItems = [["apples", "unchecked"], ["bananas", "unchecked"]]


class GroceryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var groceryItems = [[String]]()
    var groceryListID = String()
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    @IBOutlet weak var groceryTableView: UITableView!
    
    
    // 'Add New Item' button
    
    @IBAction func addNewItem(_ sender: Any) {
        let alert = UIAlertController(title:"New Grocery Item", message: nil, preferredStyle:UIAlertControllerStyle.alert)
        
        // text field
        alert.addTextField { (UITextField) in
        }
        
        // 'Add' button
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            (action) -> Void in
            
            // assigns text field entry to newItem
            let newGrocery = alert.textFields![0] as UITextField
            
            if newGrocery.text!.isEmpty{
                self.displayAlertMessage(title: "Error", message: "No Empty Fields Allowed!")
            }
            else {
                // adds newItem to groceryItems
                self.groceryItems.append([newGrocery.text!,  "unchecked"])
                self.groceryTableView.reloadData()
                let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonecreategitems.php")! as URL)
                request.httpMethod = "POST"
                
                let postString = "a=\(newGrocery.text!)&b=\(self.groceryListID)"

                
                request.httpBody = postString.data(using: String.Encoding.utf8)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
                    
                    /*
                    var json: Array<Any>!
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Array
                    } catch {
                        print(error)
                    }
                    
                    self.groceryItems = json as! [[String]]
                    
                    //print("response = \(response)")
                    */
                }
                task.resume()
                
                self.groceryTableView.reloadData()
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
        return(groceryItems.count)
    }
    
    
    // 3 functions below added by command clicking UITableViewDataSource above
    
    // adds groceryItems to tableview
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = groceryItems[indexPath.row][0]
        cell.selectionStyle = UITableViewCellSelectionStyle.gray
        cell.textLabel?.numberOfLines=0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        //cell.backgroundColor = UIColor.cyan
        
        // adds checkmark to cells that should have it
        if groceryItems[indexPath.row][1] == "checked"
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        
        return(cell)
    }
    
    //  swipe left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonedeletegitems.php")! as URL)
            request.httpMethod = "POST"
            
            let postString = "a=\(groceryItems[indexPath.row][1])"
            print("IDDDD")
            print(groceryItems[indexPath.row][1])
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                
            }
            task.resume()
            groceryItems.remove(at: indexPath.row)
            groceryTableView.reloadData()
        }
    }
    
    // changes an item's checked status when its cell is touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(groceryItems[indexPath.row])
        /*
        if groceryItems[indexPath.row][1] == "unchecked"
        {
            groceryItems[indexPath.row][1] = "checked"
        }
        else
        {
            groceryItems[indexPath.row][1] = "unchecked"
        }
        groceryTableView.reloadData()
        
     */
    }
    
    // enables 'Edit' button at top right of screen
    // might need navigation controller to work
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.groceryTableView.setEditing(editing, animated: animated)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        groceryTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        groceryTableView.reloadData()

        // 'Edit' button at top right of screen
        navigationItem.rightBarButtonItem = editButtonItem
        
        
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
