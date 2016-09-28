//
//  SplashViewController.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SplashViewController: UIViewController {
    
    //MARK: Fields

    let delay: TimeInterval = 3
    var firService: FIRProtocol = FIRService.sharedInstance
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        if let currentUser = firService.resolveCurrentlyLoggesUser() {
            print("logged user: \(currentUser)")
            showScreen(screenName: UIConsts.mainViewSegueName)
        } else {
            showScreen(screenName: UIConsts.loginViewSegueName)
        }
    }
    
    func showScreen(screenName: String){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.performSegue(withIdentifier: screenName, sender: self)
        }
    }
    
    func hideNavigationBar(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
