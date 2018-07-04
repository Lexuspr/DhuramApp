//
//  archivo.swift
//  Dhamir
//
//  Created by MAC10 on 4/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct Archivo:Codable {
    let count:Int
    let data:[DataA]
}
struct DataA:Codable {
    let id:String
    let name:String
    let tipo:String
    let fecha:String
    let file:String?
    let carpeta:String?
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case name = "name"
        case tipo = "tipo"
        case fecha = "fecha"
        case carpeta = "carpeta"
        case file = "file"
    }
}

struct ArchivoN:Codable {
    let message:String
    let data:DataAN
}
struct DataAN:Codable {
    let id:String
    let name:String
    let tipo:String
    let fecha:String
    let carpeta:String
    let file:String?
    
    enum CodingKeys: String,CodingKey {
        case id = "_id"
        case name = "name"
        case tipo = "tipo"
        case fecha = "fecha"
        case carpeta = "carpeta"
        case file = "file"
    }
}
