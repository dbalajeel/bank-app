import Foundation

// One bank account, exactly as the server sends it (AccountResponse).
struct Account: Codable, Identifiable, Hashable {
    let accountNumber: String
    let balance: Float
    let nickname: String?

    // SwiftUI lists need an "id" to tell rows apart.
    var id: String { accountNumber }
}
