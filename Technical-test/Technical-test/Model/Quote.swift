//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

struct Quote: Codable {
    let symbol: String?
    let name: String?
    let currency: String?
    let readableLastChangePercent: String? //all nil ?!
    let last: String?
    let variationColor: String? // all nil ?!
    let isin: String? // for FAV
                      //    let key: String? //?? for Fav ??
    
    weak var myMarket: Market?
    //I can presume that we want have link to Market and show several Markets but for 1 hour test task It's too much
    
    var isFavorite = false
    
    private enum CodingKeys: String, CodingKey {
        case
        symbol,
        name,
        currency,
        readableLastChangePercent,
        last,
        variationColor,
        isin
    }
}
