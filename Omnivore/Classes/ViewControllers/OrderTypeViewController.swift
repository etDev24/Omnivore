//
//  OrderTypeViewController.swift
//  Omnivore Demo
//
//  Created by apple on 2/28/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

class OrderTypeViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var textViewApiResponse: UITextView!
    @IBOutlet weak var lblSelectedMenu: UILabel!
    @IBOutlet weak var lblMenuTotalAmount: UILabel!
    
    // MARK: - Properties
    var orderTypeList = [OrderTypeModel]()
    var selectedMenu = ""
    var totalAmount = ""
    
    // MARK: - View LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMenuTotalAmount.text = totalAmount
        self.lblSelectedMenu.text = selectedMenu
        
        self.getOrderTypes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api calls
    
    func getOrderTypes() {
        
        startAnimating(type: NVActivityIndicatorType.lineSpinFadeLoader)
        
        let url = "https://api.omnivore.io/1.0/locations/i57RLepT/order_types/"
        
        let headers = ["Api-Key":"f6265e11f84847aaa1f852abcd92bd39"]
        
        NetworkManager().request(requestType: .get, requestString: url, body: nil, headers: headers, encoding: URLEncoding.default) { (response, statusCode, data) in
            let embeddedJson = data!["_embedded"] as! [String: Any]
            let orderTypesArr = embeddedJson["order_types"] as! [[String:Any]]
            for obj in orderTypesArr {
                let orderTypeModel =  OrderTypeModel.init(json:obj)
                self.orderTypeList.append(orderTypeModel!)
            }
            
            self.showOutput(having: url, parameters: nil, response: data)
            self.tblView.reloadData()
            self.stopAnimating()
        }
        
    }
    
    // MARK: - Custom Methods
    
    func showOutput(having url: String, parameters: String?, response: Any?) {
        let prettyJsonData = try? JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
        let prettyPrintedJson = NSString(data: prettyJsonData!, encoding: String.Encoding.utf8.rawValue)!
        
        self.textViewApiResponse.text = "Request URL: \(url)\n\nParameters: \(String(describing: parameters))\n\nResponse: \(String(describing: prettyPrintedJson))"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
        }
    }
    
}

extension OrderTypeViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        let orderTypeObj = orderTypeList[indexPath.row]
        
        cell.textLabel?.text = orderTypeObj.name
        cell.detailTextLabel?.text = "Available : \(orderTypeObj.isAvailable)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
}
