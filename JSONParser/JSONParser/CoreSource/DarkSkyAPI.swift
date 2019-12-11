//
//  DarkSkyAPI.swift
//  JSONParser
//
//  Created by Mike Dull on 2019/12/11.
//  Copyright © 2019 MikeDull. All rights reserved.
//

import Foundation

// API for requesting weather data
// The intact api should be https://api.darksky.net/forecast/[key]/[latitude],[longitude]

struct DarkSkyAPI {
    static let key = "4a410d6d8db079f0affe40355ccb92ef"
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var authenticatedBaseURL: URL {
        return baseURL.appendingPathComponent(key)
    }
}
