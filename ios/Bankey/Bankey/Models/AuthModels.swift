//It defines the 3 JSON shapes that the iPhone sends or receives, matching the backend’s DTOs exactly.
import Foundation

// What we send to POST /auth/login (swift to json)
struct LoginRequest: Encodable {
    let customerNumber: Int
    let password: String
}

// What the server sends back after a correct login (json to swift)
struct LoginResponse: Decodable {
    let token: String
}

// What we send to PATCH /accounts/{accountNumber}/nickname
struct NicknameRequest: Encodable {
    let nickname: String
}
