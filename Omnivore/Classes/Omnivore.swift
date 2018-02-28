//
//  Omnivore.swift
//  Omnivore
//
//  Created by mac on 2/28/18.
//

import UIKit

public class Omnivore: NSObject {
    public init(rootViewController: UIViewController, animated: Bool) {
        super.init()
        let storyboard = UIStoryboard(name: "Omnivore", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "OmnivoreRootVC")
        rootViewController.present(newViewController, animated: animated, completion: nil)
    }
}
