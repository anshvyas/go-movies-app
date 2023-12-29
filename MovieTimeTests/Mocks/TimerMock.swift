//
//  TimerMock.swift
//  MovieTimeTests
//
//  Created by Anshul Vyas on 29/12/23.
//  Copyright © 2023 Anshul Vyas. All rights reserved.
//

@testable import MovieTime
import Foundation

class TimerMock: TimerProtocol {
    static var timerMock: TimerMock!
    
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping @Sendable (TimerProtocol) -> Void) -> TimerProtocol {
        block(timerMock)
        
        return timerMock
    }
    
    var invalidateCalled: Bool = false
    func invalidate() {
        self.invalidateCalled = true
    }
}
