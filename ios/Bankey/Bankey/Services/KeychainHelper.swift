//It saves, reads and deletes the login token in the iPhone’s Keychain, a locked, encrypted safe.
//apples basic toolbox
import Foundation
//apples keychain toolbox. ksec and secitem comes from here
import Security

//enum -> A Swift type. Here we use it as a box of tools you can’t create copies of
//we are writing the name tag
enum KeychainHelper {
    //static here means it belongs to the tool box not an object like java
    //let: a constant that never changes
    // the apps name on the label
    private static let service = "com.bankey.Bankey"
    //the items name on the label
    private static let account = "authToken"

    // The "label" that finds our token in the Keychain.
    private static var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    static func saveToken(_ token: String) {
        deleteToken() // remove the old token first

        var query = baseQuery //var can be changed 
        query[kSecValueData as String] = Data(token.utf8)
        // Only readable while the phone is unlocked, and never copied to other devices.
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        SecItemAdd(query as CFDictionary, nil)
    }

    static func readToken() -> String? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func deleteToken() {
        SecItemDelete(baseQuery as CFDictionary)
    }
}
