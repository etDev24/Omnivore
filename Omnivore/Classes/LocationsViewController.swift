//
//  ViewController.swift
//  Omnivore Demo
//
//  Created by apple on 2/27/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class LocationsViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var textViewApiResponse: UITextView!
    
    // MARK: - Properties
    var locationList = [LocationModel]() {
        didSet {
            self.tblView.reloadData()
        }
    }
    
    // MARK: - View LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Api calls
    
    func getLocations() {
        
        startAnimating(type: NVActivityIndicatorType.lineSpinFadeLoader)
        
        let url = "https://api.omnivore.io/1.0/locations/"
        
        let headers = ["Api-Key":"f6265e11f84847aaa1f852abcd92bd39"]
        
        NetworkManager().request(requestType: .get, requestString: url, body: nil, headers: headers, encoding: URLEncoding.default) { (response, statusCode, data) in
            let embeddedJson = data!["_embedded"] as! [String: Any]
            if let embedded = EmbeddedModel.init(json: embeddedJson) {
                self.locationList = embedded.locations
            } else {
                print("embedded data not found")
            }
            
            self.showOutput(having: url, parameters: nil, response: data)
            
            self.stopAnimating()
        }
        
    }
    
    // MARK: - Custom Methods
    
    func showOutput(having url: String, parameters: String?, response: Any?) {
        self.textViewApiResponse.text = "Request URL: \(url)\n\nParameters: \(String(describing: parameters))\n\nResponse: \(String(describing: response))"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenuSegue" {
            let menuVC = segue.destination as! MenuViewController
            guard let index = sender else {
                return
            }
            let locationModel = locationList[index as! Int]
            print("menu href : \(locationModel.links.menu.href)")
            menuVC.menuUrl = locationModel.links.menu.href
        }
    }
    
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let locationModel = locationList[indexPath.row]
        
        cell.textLabel?.text = locationModel.name
        cell.detailTextLabel?.text = "ID : \(locationModel.id)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showMenuSegue", sender: indexPath.row)
        
    }
}

