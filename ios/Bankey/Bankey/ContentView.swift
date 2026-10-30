import SwiftUI

// Decides which screen to show: Login, or the accounts list after login.
struct ContentView: View {
    @State private var auth = AuthViewModel()

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
