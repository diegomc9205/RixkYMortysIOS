//
//  PersonajeModel.swift
//  PersonajesRickYMortys
//
//  Created by dam2 on 18/12/23.
//

import Foundation
struct Model: Decodable {
    let results: [PersonajeModel]
}
struct PersonajeModel: Decodable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: Origin?
    let location: Location?
    let image: String
    let episode: [String?]
    let url: String?
    let created: String?


}
struct Origin: Decodable {
    let name: String?
    let url: String?
}
struct Location: Decodable {
    let name: String?
    let url: String?
}

