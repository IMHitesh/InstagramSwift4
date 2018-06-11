//
//  Instagram+Error.swift
//  Capchur
//
//  Created by Hitesh Surani on 01/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

public struct InstagramError: Error {
    
    // MARK: - Properties
    
    let kind: ErrorKind
    let message: String
    
    /// Retrieve the localized description for this error.
    public var localizedDescription: String {
        return "[\(kind.description)] - \(message)"
    }
    
    // MARK: - Types
    
    enum ErrorKind: CustomStringConvertible {
        case invalidRequest
        
        var description: String {
            switch self {
            case .invalidRequest:
                return "invalidRequest"
            }
        }
    }
    
}
