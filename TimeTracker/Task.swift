//
//  Task.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 21.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class Task : Equatable {

    //MARK: Fields
    
    var name: String
    var color: UIColor
    var taskId: String
    var isEnabled: Bool
    var isRunning: Bool
    var requestInProgress: Bool
    
    var startTime: Double?
    
    //MARK: Inits
    
    init(taskName: String, backgroundColor: UIColor) {
        name = taskName
        color = backgroundColor
        taskId = NSUUID().uuidString
        isEnabled = true
        isRunning = false
        requestInProgress = false
    }
    
    init(firSnapshot: FIRDataSnapshot) {
        var snapshot = firSnapshot.value! as! [String:AnyObject]
        
        name = snapshot["name"] as! String
        taskId = snapshot["taskId"] as! String
        isEnabled = snapshot["isEnabled"] as! Bool
        isRunning = snapshot["isRunning"] as! Bool
        requestInProgress = false
        
        let colorComponents = snapshot["color"] as! NSArray
        
        let red = colorComponents[0] as? NSNumber
        let green = colorComponents[1] as? NSNumber
        let blue = colorComponents[2] as? NSNumber
        let alpha = colorComponents[3] as? NSNumber
        
        color = UIColor(colorLiteralRed: (red?.floatValue)!, green: (green?.floatValue)!,
                        blue: (blue?.floatValue)!, alpha: (alpha?.floatValue)!)
    }
    
    //MARK: Functions
    
    func toAnyObject() -> AnyObject {
        var colorList: NSArray = []
        if let colorArray = color.cgColor.components {
            colorList = [colorArray[0], colorArray[1], colorArray[2], colorArray[3]]
        }
        
        let anyObject = [
            "taskId" : taskId as AnyObject,
            "name" : name as AnyObject,
            "color" : colorList,
            "isEnabled" : isEnabled as AnyObject,
            "isRunning" : isRunning as AnyObject
        ] as [String : AnyObject]
        
        return anyObject as AnyObject
    }
    
    public static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.name == rhs.name && lhs.taskId == rhs.taskId && lhs.color == rhs.color
    }
}
