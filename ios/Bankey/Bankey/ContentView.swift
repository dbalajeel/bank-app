import SwiftUI

// Decides which screen to show: Login, or the app after login.
struct ContentView: View {
    @State private var auth = AuthViewModel()

    var body: some View {
        if auth.isLoggedIn {
            // Step 47 will put the accounts list here.
            VStack(spacing: 16) {
                Text("Logged in ✅")
                    .font(.title)
                Button("Log out") {
                    auth.logout()
                }
            }
        } else {
            LoginView(auth: auth)
        }
    }
}

#Preview {
    ContentView()
}
