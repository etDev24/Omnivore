//
//  OptionSelectionViewController.swift
//  Omnivore Demo
//
//  Created by apple on 3/1/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Alamofire

protocol OptionSelectionDelegate: class {
    func didSelected(option: PriceLevelModel)
}

class OptionSelectionViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBAction func dimiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    var optionList = [PriceLevelModel]()
    weak var delegate : OptionSelectionDelegate?
    
    // MARK: - View LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension OptionSelectionViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
        
        let priceLevelObj = optionList[indexPath.row]
        
        cell.textLabel?.text = priceLevelObj.name
        cell.detailTextLabel?.text = "Price per unit : \(priceLevelObj.price_per_unit)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let priceLevelObj = optionList[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.delegate?.didSelected(option: priceLevelObj)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.dismiss(animated: true, completion: nil)
        })
        
    }
}
