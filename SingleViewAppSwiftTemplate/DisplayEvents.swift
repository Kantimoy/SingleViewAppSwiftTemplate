//
//  Time.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Kantimoy Sur on 2019-06-21.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

class DisplayEvents {
    
    var differentEvents: [Events] = [firstEvent,secondEvent,thirdEvent,fourthEvent,fifthEvent,sixthEvent,seventhEvent,eighthEvent,ninthEvent,tenthEvent,eleventhEvent,twelvethEvent,thriteenthEvent,fourteenthEvent,fifteenthEvent,sixteenthEvent,seventeenthEvent,eigthteenthEvent,ninteenthEvent,twenthEvent,twentyfirstEvent,twentysecondEvent,twentythirdEvent,twentyfourthEvent,twentyfifthEvent]
    var eventsToDisplay = [String]()
    var eventsInAscendingOrder = [String]()
    
    func getAllEvents() -> [String] {
        for events in differentEvents {
            eventsToDisplay.append(events.events)
        }
        return eventsToDisplay
    }
    
    func checkEventsInAscendingOrder(inYear forEvents: String, compare toEvent: String) -> Bool {
        
        var currentEventYear = 0
        var comaprisonEventYear = 0
        
        for event in differentEvents {
            if forEvents == event.events {
                currentEventYear = event.eventYear
            }
            if toEvent == event.events {
                comaprisonEventYear = event.eventYear
            }
        }
        
        if currentEventYear < comaprisonEventYear {
            return true
        } else {
            return false
        }
    }
    
    
    func shuffleEvents() -> [String] {
        return eventsToDisplay.shuffled()
    }
    
    
}


