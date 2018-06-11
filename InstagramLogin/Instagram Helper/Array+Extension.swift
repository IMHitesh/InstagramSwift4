//
//  Array+Extension.swift
//  Capchur
//
//  Created by Hitesh Surani on 01/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation

extension Array where Element == InstagramScope {
    
    func joined(separator: String) -> String {
        return self.map({ "\($0.rawValue)" }).joined(separator: separator)
    }
}
