//
//  LoginViewController.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets & Actions
    
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var overlay: UIView!
    
    @IBAction func onLoginTouched(_ sender: UIButton) {
        if (textFieldLogin.text?.isEmpty)! || (textFieldPassword.text?.isEmpty)!{
            showAlert(title: UIConsts.alertTitle,
                      message: alertMessage,
                      btn: UIConsts.alertBtnTitle)
        } else {
            overlay.isHidden = false
            firService.login(login: textFieldLogin.text!, password: textFieldPassword.text!, { (user, error) in
                self.overlay.isHidden = true
                if let err = error {
                    self.showAlert(title: UIConsts.alertTitle,
                                   message: err.localizedDescription,
                                   btn: UIConsts.alertBtnTitle)
                } else{
                    self.showScreen(screenName: UIConsts.mainViewSegueName)
                }
            })
        }
    }
    
    //MARK: Fields
    
    var firService: FIRProtocol = FIRService.sharedInstance
    let alertMessage = "Credentials are empty!"
    
    //MARK: Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    
    func showScreen(screenName: String){
        performSegue(withIdentifier: screenName, sender: self)
    }
    
    func showAlert(title: String, message: String, btn: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: btn, style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNavigationBar(){
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
