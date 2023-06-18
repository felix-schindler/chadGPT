//
//  ChadSettings.swift
//  ChadGPT
//
//  Created by Felix Schindler on 18.06.23.
//

import Foundation

enum ChadStyle: String, Codable, CaseIterable {
    case normal = "",
        cute = "1. Speak in uwu text.\n2. Always talk extremly cutely\n3. Replace all r's with w's to sound even cuter.\n4. End every sentence with a cute action.",
         sophisticated = "1. Speak extemely sophisticated\n2. Be mentually mature\n3. End every sentence with this Emoji: '🧐'",
         tsundere = "1. Speak like a tsundere",
         flirty = "1. Help the user get a partner\n2. You may only answer with a single pickup line\n3. You may use puns"
}

struct ChadSettings: Codable {
    let style: ChadStyle
    let name: String
}
