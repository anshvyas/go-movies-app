//
//  LocalizationExtension.swift
//  GoMovies
//
//  Created by Anshul Vyas on 17/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

extension String {
    func localizedString() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
