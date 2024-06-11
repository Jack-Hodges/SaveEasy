//
//  AppColour.swift
//  SaveEasy
//
//  Created by Jack Hodges on 23/5/2024.
//

import SwiftUI

struct AppColour {
    let name: String
    let primaryColour: Color
    let secondaryColour: Color
    let backgroundColour: Color
    
    static let allColours: [AppColour] = [
        AppColour(name: "Blue", 
                  primaryColour: Color(red: 0.318, green: 0.525, blue: 0.573),
                  secondaryColour: Color(red: 0.4, green: 0.647, blue: 0.698),
                  backgroundColour: Color(red: 0.839, green: 0.973, blue: 1)),
        
        AppColour(name: "Red",
                  primaryColour: Color(red: 0.639, green: 0.325, blue: 0.325),
                  secondaryColour: Color(red: 0.737, green: 0.447, blue: 0.447),
                  backgroundColour: Color(red: 1, green: 0.839, blue: 0.839)),
        
        AppColour(name: "Green",
                  primaryColour: Color(red: 0.361, green: 0.541, blue: 0.361),
                  secondaryColour: Color(red: 0.388, green: 0.643, blue: 0.38),
                  backgroundColour: Color(red: 0.839, green: 1, blue: 0.839)),
        
        AppColour(name: "Orange",
                  primaryColour: Color(red: 0.937, green: 0.588, blue: 0.18),
                  secondaryColour: Color(red: 0.894, green: 0.663, blue: 0.396),
                  backgroundColour: Color(red: 1, green: 0.933, blue: 0.839)),
        
        AppColour(name: "Purple",
                  primaryColour: Color(red: 0.557, green: 0.396, blue: 0.894),
                  secondaryColour: Color(red: 0.647, green: 0.522, blue: 0.91),
                  backgroundColour: Color(red: 0.918, green: 0.831, blue: 0.969)),
        
        AppColour(name: "Yellow",
                  primaryColour: Color(red: 0.757, green: 0.718, blue: 0.392),
                  secondaryColour: Color(red: 0.847, green: 0.824, blue: 0.604),
                  backgroundColour: Color(red: 0.949, green: 0.969, blue: 0.831)),
        
        AppColour(name: "Mint",
                  primaryColour: Color(red: 0.251, green: 0.8, blue: 0.671),
                  secondaryColour: Color(red: 0.561, green: 0.839, blue: 0.773),
                  backgroundColour: Color(red: 0.886, green: 1, blue: 0.953)),
        
        AppColour(name: "Pink",
                  primaryColour: Color(red: 0.843, green: 0.475, blue: 0.718),
                  secondaryColour: Color(red: 0.89, green: 0.671, blue: 0.812),
                  backgroundColour: Color(red: 1, green: 0.906, blue: 0.957)),
    ]
    
    static func getColourScheme(by name: String) -> AppColour? {
        return allColours.first { $0.name == name }
    }
}
