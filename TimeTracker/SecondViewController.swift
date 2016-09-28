//
//  SecondViewController.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 18.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNavigationBar(){
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

