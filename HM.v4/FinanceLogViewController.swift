//
//  FinanceViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/24/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class FinanceLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    
    var payments = [String]()
    
    
    @IBOutlet weak var financeLogTable: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get finances
        self.financeLogTable.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let request1 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetdebts.php")! as URL)
        
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
                self.payments = json1 as! [String]
                self.financeLogTable.reloadData()
            }
            
            
        }
        task1.resume()
        
        }
        
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        financeLogTable.reloadData()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = payments[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)
        cell.textLabel?.numberOfLines=0 // line wrap
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        return(cell)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(payments.count)
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
