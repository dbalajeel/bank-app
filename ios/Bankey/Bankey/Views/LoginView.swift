import SwiftUI

// The login screen.
struct LoginView: View {
    @Bindable var auth: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "building.columns.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            Text("Bankey")
                .font(.largeTitle.bold())

            VStack(spacing: 12) {
                TextField("Customer number", text: $auth.customerNumber)
                    .keyboardType(.numberPad)
                    .textContentType(.username)
                SecureField("Password", text: $auth.password)
                    .textContentType(.password)
            }
            .textFieldStyle(.roundedBorder)

            if let error = auth.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task { await auth.login() }
            } label: {
                if auth.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Log in")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(auth.isLoading)

            Spacer()
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    LoginView(auth: AuthViewModel())
}
