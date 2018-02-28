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
    
    // MARK: - Properties
    var modifierUrl = ""
    var modifierGroupList = [ModifierGroupModel]()
    var menu = MenuModel()
    
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let embedded = data!["_embedded"] as! [String:Any]
            let modifiersGroupArr = embedded["modifier_groups"] as! [[String:Any]]
            //let modifiers = (modifiersGroupArr.first!["_embedded"] as! [String:Any])["modifiers"] as! [[String:Any]]
            for obj in modifiersGroupArr {
                print(obj)
                let modifierGroup =  ModifierGroupModel.init(json:obj)
                self.modifierGroupList.append(modifierGroup!)
            }
            
            self.tblView.reloadData()
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
        }
    }
    
    // MARK: - Custom Methods
    func showOutput(having url: String, parameters: String?, response: Any?) {
        self.textViewApiResponse.text = "Request URL: \(url)\n\nParameters: \(String(describing: parameters))\n\nResponse: \(String(describing: response))"
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modifierGroupObj = self.modifierGroupList[indexPath.row]
        if modifierGroupObj.embedded.modifiers.count > 0 {
            self.performSegue(withIdentifier: "showModifierSegue", sender: indexPath.row)
        } else {
            self.view.makeToast("No more Items available")
        }
    }
}
