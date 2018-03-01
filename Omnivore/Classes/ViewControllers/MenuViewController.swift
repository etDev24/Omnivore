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
    @IBOutlet weak var lblSelectedMenu: UILabel!
    @IBOutlet weak var lblMenuTotalAmount: UILabel!
    
    @IBAction func next(_ sender: Any) {
        let indexPath = self.tblView.indexPathForSelectedRow
        if indexPath != nil {
            self.performSegue(withIdentifier: "showModifierGroupSegue", sender: indexPath?.row)
        } else {
            print("index path is nil")
        }
    }
    
    // MARK: - Properties
    var selectedMenu = ""
    var menuUrl = ""
    var menuItems = [MenuItemModel]()
    var menu = MenuModel()
    var multiSelectionCount = 0
    var previousSelectedIndex: IndexPath? = nil
    
    
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
            modifierVC.selectedMenu = self.lblSelectedMenu.text!
            modifierVC.totalAmount = self.lblMenuTotalAmount.text!
        }
    }
    
    // MARK: - Custom Methods
    func showOutput(having url: String, parameters: String?, response: Any?) {
        let prettyJsonData = try? JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
        let prettyPrintedJson = NSString(data: prettyJsonData!, encoding: String.Encoding.utf8.rawValue)!
        
        self.textViewApiResponse.text = "Request URL: \(url)\n\nParameters: \(String(describing: parameters))\n\nResponse: \(String(describing: prettyPrintedJson))"
    }
    
    func addPriceInTotal(price: Float) {
        let total = (Float)(self.lblMenuTotalAmount.text ?? "0")! + price
        self.lblMenuTotalAmount.text = "\(total)"
    }
    
    func subtractPriceInTotal(price : Float) {
        let total = (Float)(self.lblMenuTotalAmount.text ?? "0")! - price
        self.lblMenuTotalAmount.text = "\(total > 0 ? total : 0.0)"
    }
    
    func addMenuItem(item: String) {
        selectedMenu = selectedMenu.appendingFormat(" -> %@", item)
        self.lblSelectedMenu.text = selectedMenu
    }
    
    func removeMenuItem(item : String) {
        selectedMenu = selectedMenu.replacingOccurrences(of: " -> \(item)", with: "")
        self.lblSelectedMenu.text = selectedMenu
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
        
        if menuItemModel.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuItemModel = menuItems[indexPath.row]
        let maxSelection = menuItemModel.embedded.option_sets.first?.maximum ?? 1
        
        if maxSelection > 1 && multiSelectionCount < maxSelection {
            multiSelectionCount += 1
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            if menuItemModel.isSelected == false {
                menuItemModel.isSelected = true
            }
            
            self.addMenuItem(item: menuItemModel.name)
            self.addPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
        }
        
        if maxSelection == 1 {
            
            if previousSelectedIndex != nil {
                tableView.cellForRow(at: previousSelectedIndex!)?.accessoryType = .none
                tableView.deselectRow(at: previousSelectedIndex!, animated: false)
                
                let menuItemModel = menuItems[previousSelectedIndex!.row]
                menuItemModel.isSelected = false
                
                self.removeMenuItem(item: menuItemModel.name)
                self.subtractPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
            }
            
            previousSelectedIndex = indexPath
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            if menuItemModel.isSelected == false {
                menuItemModel.isSelected = true
            } else {
                menuItemModel.isSelected = false
            }
            
            self.addMenuItem(item: menuItemModel.name)
            self.addPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
        }
        
        let optionVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController_id") as! OptionSelectionViewController
        optionVC.optionList = menuItemModel.embedded.price_levels
        optionVC.delegate = self
        self.navigationController?.present(optionVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let menuItemModel = menuItems[indexPath.row]
        let maxSelection = menuItemModel.embedded.option_sets.first?.maximum ?? 1
        
        if maxSelection > 1 && multiSelectionCount > 0 && multiSelectionCount <= maxSelection {
            multiSelectionCount += 1
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if menuItemModel.isSelected == true {
                menuItemModel.isSelected = false
            }
            
            self.removeMenuItem(item: menuItemModel.name)
            self.subtractPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
        }
        
        if maxSelection == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if menuItemModel.isSelected == true {
                menuItemModel.isSelected = false
            }
            
            tableView.cellForRow(at: previousSelectedIndex!)?.accessoryType = .none
            tableView.deselectRow(at: previousSelectedIndex!, animated: false)
            
            let menuItemModel = menuItems[previousSelectedIndex!.row]
            menuItemModel.isSelected = false
            previousSelectedIndex = nil
            
            self.removeMenuItem(item: menuItemModel.name)
            self.subtractPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
        }
        
    }
}

extension MenuViewController: OptionSelectionDelegate
{
    func didSelected(option: PriceLevelModel) {
        let index = self.tblView.indexPathForSelectedRow
        let menuItemModel = menuItems[(index?.row)!]
        self.subtractPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
        menuItemModel.price_per_unit = option.price_per_unit
        
        self.tblView.reloadRows(at: [index!], with: .top)
        self.tblView.selectRow(at: index!, animated: false, scrollPosition: .none)
        self.addPriceInTotal(price: menuItemModel.price_per_unit ?? 0.0)
    }
    
    
}
