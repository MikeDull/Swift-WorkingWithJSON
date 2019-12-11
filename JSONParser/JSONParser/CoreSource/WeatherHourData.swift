//
//  WeatherHourData.swift
//  JSONParser
//
//  Created by Mike Dull on 2019/12/11.
//  Copyright © 2019 MikeDull. All rights reserved.
//

import Foundation

// Data structure for saving hourly weather data

struct WeatherHourDataStore: Codable {
    let data: [WeatherHourData]
}

struct WeatherHourData: Codable {
    let time: Double
    var date: Date {
        return Date(timeIntervalSince1970: time)
    }
    let windSpeed: Double
    let temperature: Double
    let precipitation: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case windSpeed
        case temperature
        case precipitation = "precipIntensity"
    }
    
    init?(data: [String:AnyObject]) {

        guard let time = data["time"] as? Double, let windSpeed = data["windSpeed"] as? Double, let temperature = data["temperature"] as? Double, let precipIntensity = data["precipIntensity"] as? Double else {
            return nil
        }

        self.time = time
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipIntensity
    }
}


extension WeatherHourData: JSONDecodable {
    init(decoder: JSONDecoderWithKeyPath) throws {
        self.time = try decoder.decode(key: "time")
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperature = try decoder.decode(key: "temperature")
        self.precipitation = try decoder.decode(key: "precipIntensity")
    }
}

