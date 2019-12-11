//
//  WeatherData.swift
//  JSONParser
//
//  Created by Mike Dull on 2019/12/11.
//  Copyright © 2019 MikeDull. All rights reserved.
//

import Foundation

// Data structure for managing location information and hourly weather data

struct WeatherData: Codable {
    
    let latitude: Double
    let longitude: Double
    let hourData: WeatherHourDataStore
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case hourData = "hourly"
    }
    

    // JSONSerialization
    init?(data: [String:AnyObject]) {

        guard let latitude = data["latitude"] as? Double, let longitude = data["longitude"] as? Double, let hourData = data["hourly"]?["data"] as? [[String:AnyObject]] else {
            return nil
        }

        self.latitude = latitude
        self.longitude = longitude

        var buffer = [WeatherHourData]()
        for hourDataPoint in hourData {
            if let data = WeatherHourData(data: hourDataPoint) {
                buffer.append(data)
            }
        }

        self.hourData = WeatherHourDataStore(data: buffer)
    }
}

extension WeatherData: JSONDecodable {
    init(decoder: JSONDecoderWithKeyPath) throws {
        self.latitude = try decoder.decode(key: "latitude")
        self.longitude = try decoder.decode(key: "longitude")
        self.hourData = try decoder.decode(key: "hourly.data")
    }
}
