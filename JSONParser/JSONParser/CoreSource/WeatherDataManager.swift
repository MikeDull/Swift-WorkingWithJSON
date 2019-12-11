//
//  WeatherDataManager.swift
//  JSONParser
//
//  Created by Mike Dull on 2019/12/11.
//  Copyright © 2019 MikeDull. All rights reserved.
//

import Foundation

// Error Type
enum WeatherDataRequestError: String, Error {
    case FailedRequest
    case InvalidResponse
}

// Structure for requesting weather data and cast it to WeatherData
struct WeatherDataManager {
    
    typealias WeatherDataCompletionHandler = (Result<WeatherData, WeatherDataRequestError>) -> ()
    
    func weatherDataForLocation(latitude: Double = 31.48, longitude: Double = 120.26, completion: @escaping WeatherDataCompletionHandler) -> Void {
        
        let url = DarkSkyAPI.authenticatedBaseURL.appendingPathComponent("\(latitude),\(longitude)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(.FailedRequest))
                return
            }
            
            // Pass data to processor
//            self.processDataWithJSONSerialization(data: data, completion: completion)
//            self.processDataWithKeyPath(data: data, completion: completion)
            self.processDataWithJSONDecoder(data: data, completion: completion)
            
        }.resume()
    }
    
    
    // https://cocoacasts.com/building-a-weather-application-with-swift-3-decoding-json-data-in-swift-part-1
    // Use JSONSerialization to extract data
    private func processDataWithJSONSerialization(data: Data, completion: WeatherDataCompletionHandler) -> Void {
        
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] else {
            completion(Result.failure(.InvalidResponse))
            return
        }
        
        if let weatherData = WeatherData(data: jsonResult) {
            completion(Result.success(weatherData))
        } else {
            completion(Result.failure(.InvalidResponse))
        }
    }
    
    
    // https://cocoacasts.com/building-a-weather-application-with-swift-3-decoding-json-data-in-swift-part-2
    // Use KeyPath to extract data
    private func processDataWithKeyPath(data: Data, completion: WeatherDataCompletionHandler) -> Void {
        
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject] else {
            completion(Result.failure(.InvalidResponse))
            return
        }
        
        let jsonDecoder = JSONDecoderWithKeyPath(data: jsonResult)
        
        if let weatherData = try? WeatherData(decoder: jsonDecoder) {
            completion(Result.success(weatherData))
        } else {
            completion(Result.failure(.InvalidResponse))
        }
    }
    
    
    
    // https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
    // Use JSONDecoder to extract data
    private func processDataWithJSONDecoder(data: Data, completion: WeatherDataCompletionHandler) -> Void {
        
        let jsonDecoder = JSONDecoder()
        
        if let weatherData = try? jsonDecoder.decode(WeatherData.self, from: data) {
            completion(Result.success(weatherData))
        } else {
            completion(Result.failure(.InvalidResponse))
        }
    }
}
