//
//  TimeFormatter.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 26.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
class TimeFormatter {

    //MARK: Fields
    
    private static let secondsInMinute: Double = 60
    private static let secondsInHour: Double = 3600
    
    private static let secondsText = "seconds"
    private static let minutesText = "minutes"
    private static let hoursText = "hours"
    
    // MARK: Functions
    
    static func formatTimespan(timespanToFormat: Double) -> String {
        
        let roundedTimespan = timespanToFormat.rounded(FloatingPointRoundingRule.down)
        if roundedTimespan < secondsInMinute{
            return "\(Int(roundedTimespan)) " + secondsText
        } else if roundedTimespan < secondsInHour{
            let seconds = Int(roundedTimespan.truncatingRemainder(dividingBy: secondsInMinute))
            let minutes = Int(roundedTimespan / secondsInMinute)
            
            return "\(minutes) " + minutesText + "  \(seconds) " + secondsText
        } else {
            let hours = Int(roundedTimespan / secondsInHour)
            let minutes = Int((roundedTimespan.truncatingRemainder(dividingBy: secondsInHour)) / secondsInMinute)
            
            return "\(hours) " + hoursText + "  \(minutes) " + minutesText
        }
    }
}
