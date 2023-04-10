//
//  Market.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 30.04.21.
//

import Foundation


class Market: Codable {
    let marketName:String = "SMI"
    var quotes:[Quote]? = []
}
