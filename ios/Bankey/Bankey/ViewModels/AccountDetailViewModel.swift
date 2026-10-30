import Foundation
import Observation

// The "brain" of the details screen: loads one account and saves its nickname.
@Observable
final class AccountDetailViewModel {
    var account: Account
    var nicknameText: String
    var errorMessage: String?
    var successMessage: String?
    var isSaving = false
    var sessionExpired = false

    init(account: Account) {
        self.account = account
        self.nicknameText = account.nickname ?? ""
    }

    // GET /accounts/{accountNumber}: get the latest details from the server.
    func refresh() async {
        do {
            account = try await APIClient.shared.getAccount(account.accountNumber)
            nicknameText = account.nickname ?? ""
        } catch APIError.unauthorized {
            sessionExpired = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // PATCH /accounts/{accountNumber}/nickname
    func saveNickname() async {
        errorMessage = nil
        successMessage = nil

        let trimmed = nicknameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count <= 255 else {
            errorMessage = "Nickname must be 255 characters or less"
            return
        }

        isSaving = true
        defer { isSaving = false }

        do {
            account = try await APIClient.shared.updateNickname(accountNumber: account.accountNumber,
                                                                nickname: trimmed)
            nicknameText = account.nickname ?? ""
            successMessage = trimmed.isEmpty ? "Nickname removed" : "Nickname saved"
        } catch APIError.unauthorized {
            sessionExpired = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
