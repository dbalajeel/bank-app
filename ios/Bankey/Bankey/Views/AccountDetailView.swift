import SwiftUI

// The details of one account, with a box to change its nickname.
struct AccountDetailView: View {
    let auth: AuthViewModel
    let onSaved: (Account) -> Void          // tells the list about the new nickname (takes one account returns nothing)
    @State private var viewModel: AccountDetailViewModel

    init(account: Account, auth: AuthViewModel, onSaved: @escaping (Account) -> Void) { //This function will be kept and called later
        self.auth = auth //keep auth
        self.onSaved = onSaved //save the instructions the list gave us, so we can use them later, after the nickname is saved. 
        _viewModel = State(initialValue: AccountDetailViewModel(account: account)) //Create this screen’s brain with the tapped account
    }
    //balance section
    var body: some View {
        Form { //Apple’s settings-style screen: grey background, white rounded groups
            Section("Balance") {
                Text(viewModel.account.balance, format: .currency(code: "KWD"))
                    .font(.largeTitle.bold())
                    .monospacedDigit() //Digits all the same width
            }

            Section("Details") {
                LabeledContent("Account number", value: viewModel.account.accountNumber)
                LabeledContent("Nickname", value: viewModel.account.nickname ?? "None")
            }

            Section { //Form makes the screen look like the iPhone Settings app
                TextField("Nickname", text: $viewModel.nicknameText) //The box where the user types the new nickname, $ = whatever is typed goes straight into viewModel.nicknameText 
                Button {
                    Task { await save() }
                } label: {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Save nickname")
                    }
                }
                .disabled(viewModel.isSaving) //Can’t tap twice
            } header: { //Grey title: “SET NICKNAME”
                Text("Set nickname") 
            } footer: { //grey hiint below the group
                Text("Up to 255 characters. Leave it empty to remove the nickname.")
            }

                //error and success message
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

        //title and loading on open 
        .navigationTitle(viewModel.account.nickname ?? "Account") //title nickname or account
        .navigationBarTitleDisplayMode(.inline) //Small title in the middle of the top bar
        .task { //when the screen opens....
            await viewModel.refresh() //get the latest details
            checkSession() //check whether the token expired
        }
    }


    private func save() async {
        await viewModel.saveNickname() //trim → check 255 → PATCH → result
        if viewModel.successMessage != nil { //Only if it worked
            onSaved(viewModel.account) //call the list back with the updated account 
        }
        checkSession() //check whether the token expired
    }

    // Token expired -> back to the login screen.
    private func checkSession() {
        if viewModel.sessionExpired {
            auth.logout()
        }
    }
}
