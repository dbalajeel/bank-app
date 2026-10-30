import Foundation

// What we send to POST /auth/login
struct LoginRequest: Encodable {
    let customerNumber: Int
    let password: String
}

// What the server sends back after a correct login
struct LoginResponse: Decodable {
    let token: String
}

// What we send to PATCH /accounts/{accountNumber}/nickname
struct NicknameRequest: Encodable {
    let nickname: String
}
