import SwiftUI

// The details of one account, with a box to change its nickname.
struct AccountDetailView: View {
    let auth: AuthViewModel
    let onSaved: (Account) -> Void          // tells the list about the new nickname
    @State private var viewModel: AccountDetailViewModel

    init(account: Account, auth: AuthViewModel, onSaved: @escaping (Account) -> Void) {
        self.auth = auth
        self.onSaved = onSaved
        _viewModel = State(initialValue: AccountDetailViewModel(account: account))
    }

    var body: some View {
        Form {
            Section("Balance") {
                Text(viewModel.account.balance, format: .currency(code: "KWD"))
                    .font(.largeTitle.bold())
                    .monospacedDigit()
            }

            Section("Details") {
                LabeledContent("Account number", value: viewModel.account.accountNumber)
                LabeledContent("Nickname", value: viewModel.account.nickname ?? "None")
            }

            Section {
                TextField("Nickname", text: $viewModel.nicknameText)
                Button {
                    Task { await save() }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Save nickname")
                    }
                }
                .disabled(viewModel.isSaving)
            } header: {
                Text("Set nickname")
            } footer: {
                Text("Up to 255 characters. Leave it empty to remove the nickname.")
            }

            if let error = viewModel.errorMessage {
                Section {
                    Text(error).foregroundStyle(.red)
                }
            }
            if let success = viewModel.successMessage {
                Section {
                    Label(success, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
        }
        .navigationTitle(viewModel.account.nickname ?? "Account")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.refresh()
            checkSession()
        }
    }

    private func save() async {
        await viewModel.saveNickname()
        if viewModel.successMessage != nil {
            onSaved(viewModel.account)
        }
        checkSession()
    }

    // Token expired -> back to the login screen.
    private func checkSession() {
        if viewModel.sessionExpired {
            auth.logout()
        }
    }
}
