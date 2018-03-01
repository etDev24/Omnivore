//
//  ModifierGroupViewController.swift
//  Omnivore Demo
//
//  Created by apple on 2/28/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire
import Toast_Swift

class ModifierGroupViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var textViewApiResponse: UITextView!
    @IBOutlet weak var lblSelectedMenu: UILabel!
    @IBOutlet weak var lblMenuTotalAmount: UILabel!
    
    @IBAction func next(_ sender: Any) {
        let indexPath = self.tblView.indexPathForSelectedRow
        if indexPath != nil {
            let modifierGroupObj = self.modifierGroupList[(indexPath?.row)!]
            if modifierGroupObj.embedded.modifiers.count > 0 {
                self.performSegue(withIdentifier: "showModifierSegue", sender: indexPath?.row)
            } else {
                self.view.makeToast("No more Items available")
            }
        } else {
            print("Indx path is nil")
        }
        
    }
    
    // MARK: - Properties
    var selectedMenu = ""
    var totalAmount = ""
    var modifierUrl = ""
    var modifierGroupList = [ModifierGroupModel]()
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMenuTotalAmount.text = totalAmount
        self.lblSelectedMenu.text = selectedMenu
        
        self.getModifiers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api calls
    
    func getModifiers() {
        
        startAnimating(type: NVActivityIndicatorType.lineSpinFadeLoader)
        
        let url = modifierUrl
        
        let headers = ["Api-Key":"f6265e11f84847aaa1f852abcd92bd39"]
        
        NetworkManager().request(requestType: .get, requestString: url, body: nil, headers: headers, encoding: URLEncoding.default) { (response, statusCode, data) in
            print(data ?? "nothing found")
            if data != nil {
                let embedded = data!["_embedded"] as! [String:Any]
                let modifiersGroupArr = embedded["modifier_groups"] as! [[String:Any]]
                //let modifiers = (modifiersGroupArr.first!["_embedded"] as! [String:Any])["modifiers"] as! [[String:Any]]
                for obj in modifiersGroupArr {
                    print(obj)
                    let modifierGroup =  ModifierGroupModel.init(json:obj)
                    self.modifierGroupList.append(modifierGroup!)
                }
                
                self.tblView.reloadData()
            } else {
                print("No Data found...")
            }
            self.stopAnimating()
            
            self.showOutput(having: url, parameters: nil, response: data)
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModifierSegue" {
            let modifierVC = segue.destination as! ModifierViewController
            let modifierGroupObj = self.modifierGroupList[sender as! Int]
            modifierVC.modifierList = modifierGroupObj.embedded.modifiers
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

extension ModifierGroupViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifierGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        let modifierGroupObj = modifierGroupList[indexPath.row]
        
        cell.textLabel?.text = modifierGroupObj.name
        cell.detailTextLabel?.text = ""
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        let modifierGroupObj = modifierGroupList[indexPath.row]
        self.addMenuItem(item: modifierGroupObj.name)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        let modifierGroupObj = modifierGroupList[indexPath.row]
        self.removeMenuItem(item: modifierGroupObj.name)
    }
    
}
