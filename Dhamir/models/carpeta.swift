//
//  carpeta.swift
//  Dhamir
//
//  Created by MAC10 on 4/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct Carpeta:Codable {
    let count:Int
    let data:[DataC]
}

struct CarpetaN:Codable {
    let message:String
    let data:DataCN
}

struct DataC:Codable {
    let id:String
    let name:String
    let description:String
    let fecha:String
    let sedes:DataN
    let imagen:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case description = "description"
        case fecha = "fecha"
        case imagen = "imagen"
        case sedes = "sedes"
    }
}

struct DataCN:Codable {
    let id:String
    let name:String
    let description:String
    let fecha:String
    let sedes:String
    let createdAt:String
    let updatedAt:String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case description = "description"
        case fecha = "fecha"
        case sedes = "sedes"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
