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
        let bundle = Bundle(for: self.classForCoder)
        if let bundleUrl = bundle.url(forResource: "Omnivore", withExtension: "bundle"){
            if let bundle = Bundle(url: bundleUrl) {
                let storyboard = UIStoryboard(name: "Omnivore", bundle: bundle)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "OmnivoreRootVC")
                rootViewController.present(newViewController, animated: animated, completion: nil)
                return
            }
        }
        assertionFailure("Failed to load Bundle")
    }
}
