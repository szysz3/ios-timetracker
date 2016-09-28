//
//  LoginViewControllerTests.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
@testable import TimeTracker

class LoginViewControllerTests: XCTestCase {
    
    //MARK: Fields
    
    var viewController: LoginViewController!
    
    var navigationController: UINavigationController!
    let expectedInvalidEmailMessage = "The email address is badly formatted."
    let expectedEmptyCredentailsMessage = "Credentials are empty!"
    let expectedNoUserMessage = "There is no user record corresponding to this identifier. The user may have been deleted."
    let expectedTitle = "Oops!"
    let expectedBtnTitle = "OK"
    let mockedString = "fake"
    
    let requestTimeoutSec: TimeInterval = 5
    
    //MARK: Setup
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        let _ = viewController.view
    }
    
    //MARK: Tests
    
    func testLoginBtnTouchedInvalidCredentials(){
        //setup
        viewController.textFieldPassword.text = mockedString
        viewController.textFieldLogin.text = Constants.mockedNotExistEmail
        
        self.viewController.onLoginTouched(UIButton())
        
        let promise = expectation(description: "invalid user")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeoutSec) {
            let alertControler = self.viewController.presentedViewController as! UIAlertController
            
            //assert
            self.testLoginButtonTouchedHelper(expectedMessage: self.expectedNoUserMessage, alertControler: alertControler)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeoutSec * 2, handler: nil)
    }
    
    func testLoginBtnTouchedEmptyCredentials(){
        //setup
        viewController.textFieldPassword.text = ""
        viewController.textFieldLogin.text = mockedString
        
        //assert
        testLoginButtonEmptyCredentialHelper()
        
        //setup
        viewController.textFieldPassword.text = mockedString
        viewController.textFieldLogin.text = ""
        
        //assert
        testLoginButtonEmptyCredentialHelper()
        
        //setup
        viewController.textFieldPassword.text = ""
        viewController.textFieldLogin.text = ""
        
        //assert
        testLoginButtonEmptyCredentialHelper()
    }
    
    func testLoginBtnTouchedValidCredentials(){
        //setup
        viewController.textFieldPassword.text = Constants.mockedPassword
        viewController.textFieldLogin.text = Constants.mockedEmail
        
        self.viewController.onLoginTouched(UIButton())
        
        let promise = expectation(description: "valid login")
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeoutSec) {
            let topViewController = self.viewController.presentedViewController as? UITabBarController
            
            //assert
            XCTAssertNotNil(topViewController)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeoutSec * 2, handler: nil)
    }
    
    //MARK: Helpers
    
    private func testLoginButtonEmptyCredentialHelper(){
        //setup
        viewController.onLoginTouched(UIButton())
        let alertControler = viewController.presentedViewController as! UIAlertController
        
        //assert
        testLoginButtonTouchedHelper(expectedMessage: expectedEmptyCredentailsMessage, alertControler: alertControler)
    }
    
    private func testLoginButtonTouchedHelper(expectedMessage: String, alertControler: UIAlertController){
        //assert
        XCTAssertNotNil(alertControler)
        XCTAssertTrue(alertControler.title == expectedTitle)
        XCTAssertTrue(alertControler.message == expectedMessage)
        XCTAssertTrue(alertControler.actions.count == 1)
        XCTAssertTrue(alertControler.actions[0].title == expectedBtnTitle)
        XCTAssertTrue(alertControler.actions[0].style == UIAlertActionStyle.cancel)
    }
}
