//
//  FastingManager.swift
//  FastingTimer
//
//  Created by Kevin Martinez on 8/26/23.
//

import SwiftUI

enum FastingState {
    case notStarted
    case fasting
    case feeding
}


enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advance = "20:4"
    
    var fastingPeriod: Double {
        switch self {
        case .beginner: return 12
        case .intermediate: return 16
        case .advance: return 20
        }
    }
}

//MARK: - ViewModel

class FastingManager: ObservableObject {
    
    @Published private(set) var fastignState: FastingState = .notStarted
    @Published private (set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date {
        didSet {
            
            if fastignState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    @Published private(set) var endTime: Date
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    
    var feedingTime: Double {
        return (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    init() {
        
        let calendar = Calendar.current
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime
        )!
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60)
    }
    
    
    
    func toggleFastignState() {
        fastignState = fastignState == .fasting ? .feeding : .fasting
        
        startTime = Date()
        elapsedTime = 0.0
    }
    
    func track () {
        guard fastignState != .notStarted else {return}
        
        
        if endTime >= Date() {
     
            elapsed = false
        } else {
           
            elapsed = true
        }
           
        
        elapsedTime += 1
        let totalTime = fastignState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
          
    }
    
}
