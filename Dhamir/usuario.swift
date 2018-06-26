//
//  usuario.swift
//  Dhamir
//
//  Created by MAC10 on 22/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct Result: Codable {
    let message: String?
    let data: Usuario
    let token: String?
}
/*
struct Mensaje: Codable {
    let message:String?
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

struct Token: Codable {
    let token:String?
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
*/
struct Usuario : Codable {
    let id:String?
    let name:String?
    let dni:Int?
    let cel:Int?
    //let tipo_user:String
    //let tipo_contrato:String
    let email:String?
    let password:String?
    //let imagen:String
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name = "name"
        case dni = "dni"
        case cel = "cel"
        case email = "email"
        case password = "password"
    }
}
