import SwiftUI

// The list of the customer's accounts.
struct AccountsListView: View {
    let auth: AuthViewModel
    @State private var viewModel = AccountsViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.accounts) { account in
                NavigationLink(value: account) {
                    AccountRow(account: account)
                }
            }
            .navigationTitle("My Accounts")
            .navigationDestination(for: Account.self) { account in
                AccountDetailView(account: account, auth: auth) { updated in
                    viewModel.replace(updated)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log out") {
                        auth.logout()
                    }
                }
            }
            .overlay {
                if viewModel.isLoading && viewModel.accounts.isEmpty {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView("Couldn't load accounts",
                                           systemImage: "exclamationmark.triangle",
                                           description: Text(error))
                }
            }
            .refreshable { await load() }   // pull down to refresh
            .task { await load() }          // load when the screen opens
        }
    }

    private func load() async {
        await viewModel.load()
        if viewModel.sessionExpired {
            auth.logout() // back to the login screen
        }
    }
}

// One row in the list: nickname, account number and balance.
private struct AccountRow: View {
    let account: Account

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(account.nickname ?? "Account")
                    .font(.headline)
                Text(account.accountNumber)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(account.balance, format: .currency(code: "KWD"))
                .font(.headline)
                .monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AccountsListView(auth: AuthViewModel())
}
