//
//  SignUpViewContoller.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: Outlets & Actions
    
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatPassword: UITextField!
    @IBOutlet weak var overlay: UIView!
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
        for textField in textFieldCollection {
            if (textField.text?.isEmpty)! {
                showAlert(title: UIConsts.alertTitle,
                          message: alertEmptyFieldsMessage,
                          btn: UIConsts.alertBtnTitle)
                return
            }
        }
        
        if textFieldPassword.text != textFieldRepeatPassword.text{
            showAlert(title: UIConsts.alertTitle,
                      message: alertPasswordsDoesNotMatchMessage,
                      btn: UIConsts.alertBtnTitle)
            return
        }
        
        overlay.isHidden = false
        firService.signUp(login: textFieldEmail.text!, password: textFieldPassword.text!) { (firUser, error) in
            self.overlay.isHidden = true
            if let err = error {
                self.showAlert(title: UIConsts.alertTitle,
                               message: err.localizedDescription,
                               btn: UIConsts.alertBtnTitle)
            } else{
                self.showScreen(screenName: UIConsts.mainViewSegueName)
            }
        }
    }
    
    //MARK: Fields
    
    var firService: FIRProtocol = FIRService.sharedInstance
    let alertEmptyFieldsMessage = "Please fulfill all fields!"
    let alertPasswordsDoesNotMatchMessage = "Passwords does not match."
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationItem()
    }
    
    func hideNavigationItem(){
        navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func showAlert(title: String, message: String, btn: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: btn, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showScreen(screenName: String){
        performSegue(withIdentifier: screenName, sender: self)
    }
}
