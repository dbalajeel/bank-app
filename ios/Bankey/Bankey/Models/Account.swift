import Foundation
//codable -> jason to swift , identifiable -> each account has a uniqe id , hashable -> it can be used as a navigation value 
struct Account: Codable, Identifiable, Hashable {
    // let is a constant (cant be changed)
    let accountNumber: String
    let balance: Float
    //? mabey text maybe nothing 
    let nickname: String?

    //my id is my account number 
    var id: String { accountNumber }
}
