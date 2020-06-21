//
//  main.swift
//  MovieTime
//
//  Created by Anshul Vyas on 21/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation
import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName())
