//
//  SignUpViewControllerTest.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 20.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
@testable import TimeTracker

class SignUpViewControllerTest: XCTestCase {
    
    //MARK: Fields
    
    var viewController: SignUpViewController!
    
    let expectedEmptyCredentailsMessage = "Please fulfill all fields!"
    let expectedInvalidEmailMessage = "The email address is badly formatted."
    let expectedPasswordsNotMatchMessage = "Passwords does not match."
    let expectedPasswordLengthMessage = "The password must be 6 characters long or more."
    let expectedUserAlreadyExistsMessage = "The email address is already in use by another account."
    let expectedTitle = "Oops!"
    let expectedBtnTitle = "OK"
    let mockedText = "fake"
    
    var navigationControler: UINavigationController!
    let requestTimeoutSec: TimeInterval = 20
    var textFields:[UITextField] = []
    
    //MARK: Setup
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        navigationControler = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        let _ = viewController.view
        let _ = navigationControler.view
        
        textFields.append(viewController.textFieldName)
        textFields.append(viewController.textFieldEmail)
        textFields.append(viewController.textFieldSurname)
        textFields.append(viewController.textFieldPassword)
        textFields.append(viewController.textFieldRepeatPassword)
    }
    
    //MARK: Teardown
    
    override func tearDown() {
        super.tearDown()
        fillAllTextFields("")
    }
    
    //MARK: Tests
    
    func testLoginBtnTouchedValidCredentials(){
        //setup
        fillAllTextFields(mockedText)
        
        let randomPostfix = NSUUID().uuidString
        textFields[1].text = "\(randomPostfix)\(Constants.mockedNewEmail)"
        textFields[3].text = Constants.mockedPassword
        textFields[4].text = Constants.mockedPassword
        
        self.viewController.onSignUpTouched(UIButton())
        
        let promise = expectation(description: "valid login")
        DispatchQueue.main.asyncAfter(deadline: .now() + (requestTimeoutSec)) {
            let topViewController = self.viewController.presentedViewController as? UITabBarController
            
            //assert
            XCTAssertNotNil(topViewController)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeoutSec * 2, handler: nil)
    }
    
    func testSignUpBtnTouchedEmptyCredentials(){
        testSignUpBtnEmptyCredentialHelper()
        
        for index in 0..<textFields.count{
            //setup
            fillAllTextFields(mockedText)
            textFields[index].text = ""
            
            //assert
            testSignUpBtnEmptyCredentialHelper()
        }
        
        for index in 0..<textFields.count{
            //setup
            fillAllTextFields("")
            textFields[index].text = mockedText
            
            //assert
            testSignUpBtnEmptyCredentialHelper()
        }
    }
    
    func testSignUpBtnTouchedInvalidEmail(){
        //setup
        fillAllTextFields(mockedText)
        
        //assert
        testSignUpBtnTouchedHelperAsync(expectedMessage: expectedInvalidEmailMessage, expectationDesc: "invalid email")
    }

    func testSignUpBtnTouchedPasswordsLength(){
        //setup
        fillAllTextFields(mockedText)
        textFields[1].text = Constants.mockedEmail
        
        //assert
        testSignUpBtnTouchedHelperAsync(expectedMessage: expectedPasswordLengthMessage, expectationDesc: "password length")
    }
    
    func testSignUpBtnTouchedPasswordsNotMatch(){
        //setup
        fillAllTextFields(mockedText)
        textFields[4].text = "\(mockedText)\(mockedText)"
        
        //assert
        testSignUpBtnTouchedHelperAsync(expectedMessage: expectedPasswordsNotMatchMessage, expectationDesc: "password does not match")
    }
    
    func testSignUpBtnTouchedUserAlreadyExist(){
        //setup
        fillAllTextFields(mockedText)
        textFields[1].text = Constants.mockedEmail
        textFields[3].text = Constants.mockedPassword
        textFields[4].text = Constants.mockedPassword
        
        //assert
        testSignUpBtnTouchedHelperAsync(expectedMessage: expectedUserAlreadyExistsMessage, expectationDesc: "user already exists")
    }
    
    //MARK: Helpers
    
    private func testSignUpBtnTouchedHelperAsync(expectedMessage: String, expectationDesc: String){
        //setup
        self.viewController.onSignUpTouched(UIButton())
        
        let promise = expectation(description: expectationDesc)
        DispatchQueue.main.asyncAfter(deadline: .now() + requestTimeoutSec) {
            let alertControler = self.viewController.presentedViewController as! UIAlertController
            
            //assert
            self.testSignUpBtnTouchedHelper(expectedMessage: expectedMessage, alertControler: alertControler)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: requestTimeoutSec * 2, handler: nil)
    }
    
    private func testSignUpBtnEmptyCredentialHelper(){
        //setup
        viewController.onSignUpTouched(UIButton())
        let alertControler = viewController.presentedViewController as! UIAlertController
        
        //assert
        testSignUpBtnTouchedHelper(expectedMessage: expectedEmptyCredentailsMessage, alertControler: alertControler)
    }
    
    private func testSignUpBtnTouchedHelper(expectedMessage: String, alertControler: UIAlertController){

        //assert
        XCTAssertNotNil(alertControler)
        XCTAssertTrue(alertControler.title == expectedTitle)
        XCTAssertTrue(alertControler.message == expectedMessage)
        XCTAssertTrue(alertControler.actions.count == 1)
        XCTAssertTrue(alertControler.actions[0].title == expectedBtnTitle)
        XCTAssertTrue(alertControler.actions[0].style == UIAlertActionStyle.cancel)
    }
    
    private func fillAllTextFields(_ stringToFill: String){
        for textField in textFields {
            textField.text = stringToFill
        }
    }
}
