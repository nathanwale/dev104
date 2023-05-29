//
//  UserDefaultsStore.swift
//  RecipeApp
//
//  Created by Nathan Wale on 24/5/2023.
//

import Foundation

//
// UserDefaultsStore:
//   can save and load from User Defaults
//
protocol UserDefaultsStore where StoreType: Codable
{
    // type for storage
    associatedtype StoreType
    
    // key to store on user defaults
    var storageKey: String { get }
    
    // function to return new StoreType if it doesn't exist
    func newStore() -> StoreType
}


//
// implementation
//
extension UserDefaultsStore
{
    //
    // Load contents of User Defaults key as associated type
    //
    func load() -> StoreType
    {
        // attempt to load contents of file
        // else return newStore()
        guard
            // get contents as string
            let asString = UserDefaults.standard.string(forKey: storageKey),
            // convert string to Data
            let data = asString.data(using: .utf8),
            // decode data
            let decoded = try? JSONDecoder().decode(StoreType.self, from: data)
        else {
            // if anything fails, return new store representation
            return newStore()
        }
        
        // return decoded data as StoreType
        return decoded
    }
    
    
    //
    // Save DataType to file as JSON Encoding
    //
    func save(store: StoreType)
    {
        let data = try! JSONEncoder().encode(store)
        let asString = String(data: data, encoding: .utf8)
        UserDefaults.standard.set(asString, forKey: storageKey)
    }
    
}
