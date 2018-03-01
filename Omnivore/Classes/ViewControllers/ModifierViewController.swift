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
    @IBOutlet weak var lblSelectedMenu: UILabel!
    @IBOutlet weak var lblMenuTotalAmount: UILabel!
    
    @IBAction func next(_ sender: Any) {
        self.performSegue(withIdentifier: "orderTypeSegue", sender: nil)
    }
    
    // MARK: - Properties
    var selectedMenu = ""
    var totalAmount = ""
    var modifierUrl = ""
    var modifierList = [ModifierModel]()
    var menu = MenuModel()
    var multiSelectionCount = 0
    var previousSelectedIndex: IndexPath? = nil
    
    
    // MARK: - View LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMenuTotalAmount.text = totalAmount
        self.lblSelectedMenu.text = selectedMenu
        
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderTypeSegue" {
            let orderTypeVC = segue.destination as! OrderTypeViewController
            orderTypeVC.selectedMenu = self.lblSelectedMenu.text!
            orderTypeVC.totalAmount = self.lblMenuTotalAmount.text!
        }
    }
    
    // MARK: - Custom Methods
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
        
        if modifierObj.isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        var modifierObj = modifierList[indexPath.row]
        let maxSelection = modifierObj.embedded.option_sets.first?.maximum ?? 1
        
        if maxSelection > 1 && multiSelectionCount < maxSelection {
            multiSelectionCount += 1
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            if modifierObj.isSelected == false {
                modifierObj.isSelected = true
            }
            
            self.addMenuItem(item: modifierObj.name)
            self.addPriceInTotal(price: modifierObj.price_per_unit ?? 0.0)
        }
        
        if maxSelection == 1 {
            
            if previousSelectedIndex != nil {
                tableView.cellForRow(at: previousSelectedIndex!)?.accessoryType = .none
                tableView.deselectRow(at: previousSelectedIndex!, animated: false)
                
                var modifObj = modifierList[previousSelectedIndex!.row]
                modifObj.isSelected = false
                
                self.removeMenuItem(item: modifObj.name)
                self.subtractPriceInTotal(price: modifObj.price_per_unit ?? 0.0)
            }
            
            previousSelectedIndex = indexPath
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            if modifierObj.isSelected == false {
                modifierObj.isSelected = true
            } else {
                modifierObj.isSelected = false
            }
            
            self.addMenuItem(item: modifierObj.name)
            self.addPriceInTotal(price: modifierObj.price_per_unit ?? 0.0)
        }
        
        if modifierObj.embedded.price_levels.count > 0 {
            let optionVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionSelectionViewController_id") as! OptionSelectionViewController
            optionVC.optionList = modifierObj.embedded.price_levels
            optionVC.delegate = self
            self.navigationController?.present(optionVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        var modifierObj = modifierList[indexPath.row]
        let maxSelection = modifierObj.embedded.option_sets.first?.maximum ?? 1
        
        if maxSelection > 1 && multiSelectionCount > 0 && multiSelectionCount <= maxSelection {
            multiSelectionCount += 1
            
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if modifierObj.isSelected == true {
                modifierObj.isSelected = false
            }
            
            self.removeMenuItem(item: modifierObj.name)
            self.subtractPriceInTotal(price: modifierObj.price_per_unit ?? 0.0)
        }
        
        if maxSelection == 1 {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if modifierObj.isSelected == true {
                modifierObj.isSelected = false
            }
            
            tableView.cellForRow(at: previousSelectedIndex!)?.accessoryType = .none
            tableView.deselectRow(at: previousSelectedIndex!, animated: false)
            
            var modifierObj = modifierList[previousSelectedIndex!.row]
            modifierObj.isSelected = false
            previousSelectedIndex = nil
            
            self.removeMenuItem(item: modifierObj.name)
            self.subtractPriceInTotal(price: modifierObj.price_per_unit ?? 0.0)
        }
    }
    
}

extension ModifierViewController: OptionSelectionDelegate
{
    func didSelected(option: PriceLevelModel) {
        if let index = self.tblView.indexPathForSelectedRow {
            var modifierObj = modifierList[(index.row)]
            modifierObj.price_per_unit = option.price_per_unit
            modifierObj.isSelected = true
            
            modifierList[index.row] = modifierObj
            
            self.tblView.reloadRows(at: [index], with: .top)
            self.tblView.selectRow(at: index, animated: false, scrollPosition: .none)
        }
    }
    
    
}

