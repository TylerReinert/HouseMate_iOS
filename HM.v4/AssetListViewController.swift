//
//  GroceryViewController.swift
//  HouseMate
//
//  Created by Sean Davis on 3/22/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

var assetList = [[String]]()
var assetID = String()


class AssetListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    func displayAlertMessage(title:String,message:String)
    {
        let alertController = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        alertController.addAction(okAction);
        self.present(alertController, animated:true, completion:nil);
        
    }
    
    
    
    @IBOutlet weak var assetListTableView: UITableView!
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(assetList.count)
    }
    
    
    // 3 functions below added by command clicking UITableViewDataSource above
    
    // adds assetList to tableview
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = assetList[indexPath.row][0]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return(cell)
    }

    
    
    // select item from list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // pass asset id to next view controller
        assetID = assetList[indexPath.row][1]
        
        self.performSegue(withIdentifier: "viewAsset", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        assetListTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        
        //assetList = [["thing 1", "1"], ["thing 2", "2"]]
        
        
         super.viewDidLoad()
         let request2 = NSMutableURLRequest(url: NSURL(string: "http://cgi.soic.indiana.edu/~team54/capstonegetassets.php")! as URL)
         
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
            DispatchQueue.main.async {
                assetList = json as! [[String]]
            }
            
            
        }
        task2.resume()
        
    }
         override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
         
         
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewAsset" {
            let ViewAssetViewController:ViewAssetViewController = segue.destination as! ViewAssetViewController;
            ViewAssetViewController.assetID = assetID
        }
    }
    
}
