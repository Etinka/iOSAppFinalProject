//
//  GeneralExtensiont.swift
//  iOSFinalProject
//
//  Created by Eti Negev on 15/12/2018.
//  Copyright © 2018 Eti Negev. All rights reserved.
//

import Foundation


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        //        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        //        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
        guard !self.lowercased().hasPrefix("mailto:") else { return false }
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        let matches = emailDetector.matches(in: self, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else { return false }
        return matches[0].url?.scheme == "mailto"
    }
}
