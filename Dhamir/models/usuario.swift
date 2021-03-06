//
//  usuario.swift
//  Dhamir
//
//  Created by MAC10 on 22/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import Foundation

struct Result: Codable {
    let message: String
    let data: Usuario
    let token: String
}
struct ResultR: Codable {
    let message: String
    let data: UsuarioR
    let token: String
}

struct Usuarios: Codable {
    let count: Int?
    let data: [Usuario]
}
struct UsuarioU: Codable {
    let data: Usuario
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
    let id:String
    let name:String
    let dni:Int
    let cel:Int
    //let tipo_user:String
    //let tipo_contrato:String
    let email:String
    let tipo_user:String?
    let imagen:String?
    let createdAt:String?
    let updatedAt:String?
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name = "name"
        case dni = "dni"
        case cel = "cel"
        case email = "email"
//        case password = "password"
        case imagen = "imagen"
        case tipo_user = "tipo_user"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}
struct UsuarioR : Codable {
    let id:String
    let name:String
    let dni:Int
    let cel:Int
    //let tipo_user:String
    //let tipo_contrato:String
    let email:String
    let tipo_user:String
//    let password:String
    //let imagen:String
    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name = "name"
        case dni = "dni"
        case cel = "cel"
        case email = "email"
        case tipo_user = "tipo_user"
//        case password = "password"
    }
}

extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
