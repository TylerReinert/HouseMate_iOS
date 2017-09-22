//
//  HomeViewController.swift
//  HM.v4
//
//  Created by Roberto Konanz on 3/4/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet var name: UILabel!
    @IBOutlet var house: UILabel!
    //date label
    @IBOutlet weak var Todaysdate: UILabel!
    
    //settings button
    @IBAction func tosetting123(_ sender: UIButton) {
        self.performSegue(withIdentifier: "hometosettingsss", sender: self)
    }
    
    
    
    // get current date
    func currentdate() -> String {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        // regex
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let datestr = dateFormatter.string(from: date as Date)
        self.Todaysdate.text = datestr
        return datestr
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            

            let fname = (json[0]) as! String
            let houseName = (json[1]) as! String
            
            print("\n\n\n")
            print(fname)
            print(houseName)
            print("\n\n\n")
            
            DispatchQueue.main.async {
                self.name.text = ("Welcome, " + fname as String?)! + "!"
                self.house.text = houseName as String?
                self.currentdate()
            }

        }
        task.resume()
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
