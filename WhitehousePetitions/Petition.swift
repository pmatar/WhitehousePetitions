//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Paul Matar on 01/06/2022.
//

import Foundation
 
struct Petition: Decodable {
    var title: String
    var body: String
    var signatureCount: Int
    
}

struct Petitions: Decodable {
    var results: [Petition]
}

enum Links {
    static let realURL = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    static let sampleURL = "https://www.hackingwithswift.com/samples/petitions-1.json"
    static let topRealURL = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
    static let topSampleURL = "https://www.hackingwithswift.com/samples/petitions-2.json"
}
