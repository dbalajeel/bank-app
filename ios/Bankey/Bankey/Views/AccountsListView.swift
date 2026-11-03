import SwiftUI

// The list of the customer's accounts.
struct AccountsListView: View {
    let auth: AuthViewModel
    //state: create it once and keep it alive while this screen exists
    @State private var viewModel = AccountsViewModel()

    var body: some View {
        NavigationStack { // allow moving between screens 
            List(viewModel.accounts) { account in // Make a scrollable list with one row per account
                NavigationLink(value: account) { //Make the row tappable. Tapping it sends this account to open the details
                    AccountRow(account: account) //what the row looks like (mentioned down)
                }
            }
            
            //title and where tapping goes 
            .navigationTitle("My Accounts") // big title at the top
            .navigationDestination(for: Account.self) { account in //When a row sends an Account, open… , with that account
                AccountDetailView(account: account, auth: auth) { updated in //the details screen
                    viewModel.replace(updated) //When the details screen saves a new nickname, give me the updated account, and I’ll replace it in the list
                }
            }

            //logout button
            .toolbar { //add items to the top bar
                ToolbarItem(placement: .topBarTrailing) { //One item on the top right
                    Button("Log out") { //label
                        auth.logout() // delete the token
                    }
                }
            }

            .overlay { //draw something on top of the list
                if viewModel.isLoading && viewModel.accounts.isEmpty {
                    ProgressView() // if its loading and the account is empty show the loading icon
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView("Couldn't load accounts",
                                           systemImage: "exclamationmark.triangle", //triangle icon
                                           description: Text(error)) // error message underneath
                }
            }
            .refreshable { await load() }   // pull down to refresh
            .task { await load() }          // load when the screen opens
        }
    }

    private func load() async {
        await viewModel.load() //ask to get accounts
        if viewModel.sessionExpired {
            auth.logout() // back to the login screen
        }
    }
}

// One row in the list: nickname, account number and balance.
private struct AccountRow: View {
    let account: Account

    var body: some View {
        HStack { //Horizontal stack: puts things side by side 
            VStack(alignment: .leading, spacing: 4) {
                Text(account.nickname ?? "Account") //The nickname, or “Account” if there’s none
                    .font(.headline) //bold main text
                Text(account.accountNumber) //the number underneath
                    .font(.subheadline) //smaller grey
                    .foregroundStyle(.secondary) //smaller grey
            }
            Spacer()
            Text(account.balance, format: .currency(code: "KWD"))
                .font(.headline) //bold text
                .monospacedDigit() //All digits the same width
        }
        .padding(.vertical, 4) //A little space above and below the row only
    }
}
//Xcode’s preview only. Not part of the real app.
#Preview {
    AccountsListView(auth: AuthViewModel())
}
