//
//  ViewController.swift
//  TestApp
//
//  Created by Yaroslav Vorontsov on 29.11.2017.
//  Copyright © 2017 Yaroslav Vorontsov. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let keychainManager = KeychainManager()
        keychainManager.savePassword("supersecretpassword", for: "passwordkey", with: "Just a generic label")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            keychainManager.dumpAllAttributes(for: "passwordkey")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

