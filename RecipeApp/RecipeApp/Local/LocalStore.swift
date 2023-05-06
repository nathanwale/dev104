//
//  LocalStore.swift
//  RecipeApp
//
//  Created by Nathan Wale on 5/5/2023.
//

import Foundation

//
// LocalStore:
//   can save and load from local storage
//
protocol LocalStore where StoreType: Codable
{
    associatedtype StoreType
    var fileName: String { get }
    func newStore() -> StoreType
}


//
// implementation
//
extension LocalStore
{
    //
    // URL of local file, based on self.fileName
    //
    func fileUrl() throws -> URL
    {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        .appending(path: fileName)
        .appendingPathExtension("data")
    }
    
    
    //
    // Load contents of file as associated type
    //
    func loadFromFile() throws -> StoreType
    {
        // get url
        let fileUrl = try self.fileUrl()
        
        // attempt to load contents of file
        // else return newStore()
        guard let data = try? Data(contentsOf: fileUrl) else {
            return newStore()
        }
        
        // decode contents of file
        let decoded = try JSONDecoder().decode(StoreType.self, from: data)
        
        // return data as StoreType
        return decoded
    }
    
    
    //
    // Save DataType to file as JSON Encoding
    //
    func saveToFile(store: StoreType) throws
    {
        let data = try JSONEncoder().encode(store)
        let fileUrl = try fileUrl()
        print("Saving to \(fileUrl)")
        try data.write(to: fileUrl)
    }
    
}
