//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

class DataManager {

    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"

    typealias ResultMarket = Result<Market, Error>

    func fetchQuotes(completionHandler: @escaping (ResultMarket) ->()) {
        guard let url = URL(string: Self.path) else {
            completionHandler(Result.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.quotesTask(with: url) { quotes, response, error in
            guard
                let quotes = quotes,                        // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                var result = ResultMarket.failure(URLError(.badServerResponse))

                if let error {
                    result = ResultMarket.failure(error)
                }

                completionHandler(result)
                return
            }

            print(quotes)

            //conversion [Quites] to Market
            let market = Market()

            //applying Favorites
            quotes.forEach{ quote in
                var q = quote
                if let key = q.isin {
                    q.isFavorite = FavoritesManager.shared.isFavorite(key)
                }
                market.quotes?.append(q)
            }

            completionHandler(ResultMarket.success(market))
        }

        task.resume()
    }
}

// MARK: - Helper functions for creating encoders and decoders
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

// MARK: - URLSession response handlers
extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func quotesTask(with url: URL, completionHandler: @escaping ([Quote]?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
