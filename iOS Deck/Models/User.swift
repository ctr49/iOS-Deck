// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

struct User: Codable {
    let userName: String
    let serverURL: String
}

struct UserAuth: Codable {
    let user: User
    let password: String
}
