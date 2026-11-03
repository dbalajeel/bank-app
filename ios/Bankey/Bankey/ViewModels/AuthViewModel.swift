import Foundation
import Observation

// The "brain" of the login screen: checks input, logs in, logs out.
//watch my variables when one changes it updates by itself 
@Observable
final class AuthViewModel {
    var customerNumber = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false

    // If a token is already in the Keychain, start logged in.
    var isLoggedIn = KeychainHelper.readToken() != nil

//the login button calls this function 
    func login() async {
        errorMessage = nil //clear the old error before trying again 

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
        // defer: run this at the very end 
        defer { isLoading = false }

        //call the server
        do {
            let token = try await APIClient.shared.login(customerNumber: number, password: password)
            KeychainHelper.saveToken(token)
            password = "" // don't keep the password in memory
            isLoggedIn = true //go to account screen 
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        KeychainHelper.deleteToken()
        customerNumber = ""
        password = ""
        isLoggedIn = false //switch back to login screen
    }
}
