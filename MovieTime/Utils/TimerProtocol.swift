//
//  TimerProtocol.swift
//  MovieTime
//
//  Created by Anshul Vyas on 29/12/23.
//  Copyright © 2023 Anshul Vyas. All rights reserved.
//

import Foundation

protocol TimerProtocol {
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping @Sendable (TimerProtocol) -> Void) -> TimerProtocol
    func invalidate()
}

extension Timer: TimerProtocol {
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping @Sendable (TimerProtocol) -> Void) -> TimerProtocol {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { (timer: Timer) in
            block(timer)
        }
    }
}
