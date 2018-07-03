//
//  sede.swift
//  Dhamir
//
//  Created by MAC10 on 3/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct SedeN:Codable {
    let message:String
    let data:DataN
}
struct DataN:Codable {
    let id:String
    let name:String
    let description:String
    let createdAt:String
    let updatedAt:String
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case name = "name"
        case description = "description"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
//--------------------------------------
struct Sedes:Codable {
    let count:Int
    let data:[DataS]
}
struct DataS:Codable {
    let id:String
    let name:String
    let description:String
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case name = "name"
        case description = "description"
    }
}
