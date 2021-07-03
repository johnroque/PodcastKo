//
//  AppUserDefaults.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 8/5/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

/*
    
Service class for userdefaults usage.
*/
class AppUserDefaults {
    
    static let shared = {
        return AppUserDefaults()
    }()
    
    let defaults = UserDefaults.init(suiteName: "group.com.johnroque.PodcastsKo")!
    
    private init() {
    }
    
    // MARK: - Functions
    
    /// Stores object.
    func store<T: Encodable>(_ object: T, key: AppUserDefaultsKeys) {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(object)
        
        if encoded == nil {
            defaults.set(object, forKey: key.stringValue)
            return
        }
        
        defaults.set(encoded, forKey: key.stringValue)
    }
    
    /// Remove
    func removeDefaultsWithKey(_ key: AppUserDefaultsKeys) {
        defaults.removeObject(forKey: key.stringValue)
    }
    
    // Returns stored object (optional) if any.
    func getObjectWithKey<T: Decodable>(_ key: AppUserDefaultsKeys, type: T.Type) -> T? {
        if let savedData = defaults.data(forKey: key.stringValue) {
            let object = try? JSONDecoder().decode(type, from: savedData)
            return object
        }
        
        return defaults.object(forKey: key.stringValue) as? T
    }
}

enum AppUserDefaultsKeys: CodingKey {
    case favoritedPodcastKey
    case downloadEpisodeKey
}
