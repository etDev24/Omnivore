//
//  MenuViewController.swift
//  Omnivore Demo
//
//  Created by apple on 2/27/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

class MenuViewController: UIViewController, NVActivityIndicatorViewable {

    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var textViewApiResponse: UITextView!
    
    // MARK: - Properties
    var menuUrl = ""
    var menuItems = [MenuItemModel]()
    var menu = MenuModel()
    
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api calls
    
    func getMenu() {
        
        startAnimating(type: NVActivityIndicatorType.lineSpinFadeLoader)
        
        let url = menuUrl
        
        let headers = ["Api-Key":"f6265e11f84847aaa1f852abcd92bd39"]
        
        NetworkManager().request(requestType: .get, requestString: url, body: nil, headers: headers, encoding: URLEncoding.default) { (response, statusCode, data) in
            print(data ?? "nothing found")
            if let menu = MenuModel.init(json: data as? [String : Any]) {
                self.menu = menu
                self.getItems(for: menu.links.items.href)
            } else {
                print("embedded data not found")
            }
            //self.stopAnimating()
            
            self.showOutput(having: url, parameters: nil, response: data)
        }
        
    }
    
    func getItems(for url: String?) {
        
        //startAnimating(type: NVActivityIndicatorType.lineSpinFadeLoader)
        
        let url = url ?? ""
        
        let headers = ["Api-Key":"f6265e11f84847aaa1f852abcd92bd39"]
        
        NetworkManager().request(requestType: .get, requestString: url, body: nil, headers: headers, encoding: URLEncoding.default) { (response, statusCode, data) in
            print("menu item response : \(data ?? "nothing found" as AnyObject)")
            if data != nil {
                print("embedded key contains : \(data!["_embedded"])")
                let embedded = data!["_embedded"] as! [String:Any]
                let menuItemObjs = embedded["menu_items"] as? [[String : Any]]
                
                for obj in menuItemObjs! {
                    print(obj)
                    let menuItem =  MenuItemModel.init(json:obj)
                    self.menuItems.append(menuItem!)
                }
                print("menuItems array contains : \(self.menuItems)")
                print("first menu item name : \(String(describing: menuItemObjs))")
                
                self.tblView.reloadData()
            }
            
            self.showOutput(having: url, parameters: nil, response: data)
            
            self.stopAnimating()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModifierGroupSegue" {
            let modifierVC = segue.destination as! ModifierGroupViewController
            print("modifier href : \(menu.links.modifier_groups.href)")
            modifierVC.modifierUrl = menu.links.modifier_groups.href
        }
    }
    
    // MARK: - Custom Methods
    func showOutput(having url: String, parameters: String?, response: Any?) {
        self.textViewApiResponse.text = "Request URL: \(url)\n\nParameters: \(String(describing: parameters))\n\nResponse: \(String(describing: response))"
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        let menuItemModel = menuItems[indexPath.row]
        
        cell.textLabel?.text = menuItemModel.name
        cell.detailTextLabel?.text = "Price per unit : \(String(describing: menuItemModel.price_per_unit ?? 0.0))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showModifierGroupSegue", sender: indexPath.row)
    }
}
