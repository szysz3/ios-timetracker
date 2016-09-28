//
//  LaunchViewControllerTests.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 19.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import XCTest
@testable import TimeTracker

class SplashViewControllerTests: XCTestCase {
    
    //MARK: Fields
    
    var viewController: SplashViewController!
    
    var navigationController: UINavigationController!
    var navigationDelay: TimeInterval!
    
    //MARK: Setup
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! SplashViewController
        
        navigationDelay = viewController.delay + 5
    }
    
    //MARK: Tests
    
    func testShowNavigationBar(){
        //setup
        postSetup()
        
        //assert
        XCTAssertTrue((viewController.navigationController?.navigationBar.isHidden)!)
        XCTAssertTrue((!viewController.navigationItem.hidesBackButton))
    }
    
    func testUserAlreadyLogged() {
        //setup
        let firServiceMocked = FIRServiceMock()
        firServiceMocked.resolveCurrentlyLoggesUserClosure = getLoggedMockedUser
        
        viewController.firService = firServiceMocked
        postSetup()
        
        let promise = expectation(description: "logged navigation")
        DispatchQueue.main.asyncAfter(deadline: .now() + navigationDelay) {
            let topViewController = self.navigationController.topViewController as? UITabBarController
            
            //assert
            XCTAssertNotNil(topViewController)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: viewController.delay + (navigationDelay * 2), handler: nil)
    }
    
    func testUserNotLogged() {
        //setup
        let firServiceMocked = FIRServiceMock()
        firServiceMocked.resolveCurrentlyLoggesUserClosure = getNilMockedUser
        
        viewController.firService = firServiceMocked
        postSetup()
        
        let promise = expectation(description: "not logged navigation")
        DispatchQueue.main.asyncAfter(deadline: .now() + navigationDelay) {
            let topViewController = self.navigationController.topViewController as? LoginViewController
            
            //assert
            XCTAssertNotNil(topViewController)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: viewController.delay + (navigationDelay * 2), handler: nil)
    }
    
    
    //MARK: Helpers
    
    private func postSetup(){
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        let _ = navigationController.view
        let _ = viewController.view
    }
    
    private func getLoggedMockedUser() -> User? {
        let user = User(id: NSUUID().uuidString, email: Constants.mockedEmail)

        return user
    }
    
    private func getNilMockedUser() -> User? {
        return nil
    }
}
