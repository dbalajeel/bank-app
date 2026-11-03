import Foundation
import Observation

// The "brain" of the accounts list: loads the customer's accounts.
@Observable
final class AccountsViewModel {
    var accounts: [Account] = []
    var errorMessage: String?
    var isLoading = false
    var sessionExpired = false

    func load() async {
        isLoading = true
        //run at he end and clear any old errors
        defer { isLoading = false }
        errorMessage = nil

        do {
            accounts = try await APIClient.shared.getAccounts()
        } catch APIError.unauthorized {
            sessionExpired = true // token expired -> the screen will log out
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Find the account with the same number and swap in the updated one (new nickname)
    func replace(_ updated: Account) {
        if let index = accounts.firstIndex(where: { $0.id == updated.id }) {
            accounts[index] = updated
        }
    }
}
