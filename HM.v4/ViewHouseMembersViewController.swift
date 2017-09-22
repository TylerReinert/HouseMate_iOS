//
//  ViewHouseMembersViewController.swift
//  HM.v4
//
//  Created by Tyler Reinert on 3/31/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class ViewHouseMembersViewController: UIViewController {
    
    // array and list for house members
    var people = [String]()
    
    
    //house name
    @IBOutlet weak var housename: UILabel!
    
    
    //add back to settings button
    @IBAction func viewhousebacktosettings(_ sender: UIButton) {
        self.performSegue(withIdentifier: "viewmembacktosettings", sender: self)
    }
    
    
    
    
    @IBOutlet weak var roommatetextfield: UITextView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get house name for house label
        let request = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonehome.php")! as URL)
        
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
            
            let houseName = (json[1]) as! String
            
            // update house name and members
            DispatchQueue.main.async {
                self.housename.text = houseName as String?
                
            }
        }
        task.resume()
        
        let request2 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegethousemembers.php")! as URL)
        
        let task2 = URLSession.shared.dataTask(with: request2 as URLRequest) {
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
            
            DispatchQueue.main.async {
                self.people =  json as! [String]
                //set members textfield
                self.roommatetextfield.text = self.people.joined(separator: "\n")
                print(self.people)
            }
            
            
            
        }
        task2.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
