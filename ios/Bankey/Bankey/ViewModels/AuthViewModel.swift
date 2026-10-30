import Foundation
import Observation

// The "brain" of the login screen: checks input, logs in, logs out.
@Observable
final class AuthViewModel {
    var customerNumber = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false

    // If a token is already in the Keychain, start logged in.
    var isLoggedIn = KeychainHelper.readToken() != nil

    func login() async {
        errorMessage = nil

        // Check the input before calling the server.
        guard customerNumber.count == 9, let number = Int(customerNumber) else {
            errorMessage = "Customer number must be 9 digits."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let token = try await APIClient.shared.login(customerNumber: number, password: password)
            KeychainHelper.saveToken(token)
            password = "" // don't keep the password in memory
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        KeychainHelper.deleteToken()
        customerNumber = ""
        password = ""
        isLoggedIn = false
    }
}
