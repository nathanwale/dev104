//
//  ImageRequest.swift
//  RecipeApp
//
//  Created by Nathan Wale on 20/4/2023.
//

import UIKit

enum ImageRequestError: Error
{
    case couldNotInitialiseFromData
    case imageDataMissing
}

struct ImageRequest
{
    let url: URL

    func send() async throws -> UIImage
    {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.couldNotInitialiseFromData
        }
        
        return image
    }
}
