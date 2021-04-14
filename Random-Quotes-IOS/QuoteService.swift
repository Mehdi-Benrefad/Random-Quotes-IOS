//
//  QuoteService.swift
//  Random-Quotes-IOS
//
//  Created by Mehdi Benrefad on 14/04/2021.
//  Copyright © 2021 Mehdi Benrefad. All rights reserved.
//

import Foundation

class QuoteService {
    private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!

    static func getQuote() {
        let request = createQuoteRequest()
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                        let text = responseJSON["quoteText"],
                        let author = responseJSON["quoteAuthor"] {
                            getImage { (data) in
                            if let data = data {
                                print(data)
                                print(text)
                                print(author)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }

    private static func createQuoteRequest() -> URLRequest {
        var request = URLRequest(url: quoteUrl)
        request.httpMethod = "POST"

        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    private static func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: pictureUrl) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completionHandler(data)
                }
            }
        }
        task.resume()
    }
}
