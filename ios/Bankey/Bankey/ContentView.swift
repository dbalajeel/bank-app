import SwiftUI

// Decides which screen to show: Login or the accounts list after login.
struct ContentView: View {
    //state keeps the authviewmodel alive
    @State private var auth = AuthViewModel()

//if login true show account lists if not show login 
    var body: some View {
        if auth.isLoggedIn {
            AccountsListView(auth: auth)
        } else {
            LoginView(auth: auth)
        }
    }
}

#Preview {
    ContentView()
}
