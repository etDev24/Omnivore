//
//  ModifierViewController.swift
//  Omnivore Demo
//
//  Created by apple on 2/28/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

class ModifierViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var textViewApiResponse: UITextView!
    
    // MARK: - Properties
    var modifierUrl = ""
    var modifierList = [ModifierModel]()
    var menu = MenuModel()
    
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api calls
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenuSegue" {
            let menuVC = segue.destination as! MenuViewController
            print("menu href : \(menu.links.modifier_groups.href)")
            menuVC.menuUrl = menu.links.modifier_groups.href
        }
    }
    
}

extension ModifierViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifierList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        let modifierObj = modifierList[indexPath.row]
        
        cell.textLabel?.text = modifierObj.name
        cell.detailTextLabel?.text = "Price per unit : \(String(describing: modifierObj.price_per_unit ?? 0.0))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
