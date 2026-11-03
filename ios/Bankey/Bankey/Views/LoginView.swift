import SwiftUI

// The login screen. what the user sees and taps
struct LoginView: View {
    //bindable: Lets the text fields write directly into the ViewModel’s variables
    @Bindable var auth: AuthViewModel
    // what to draw? returns a screen piece
    var body: some View {
        //vstack puts thigs on top of each other 
        // 24 points of space between each item 
        VStack(spacing: 24) {
            //empty space, pushing things toward the middle
            Spacer()

            // logo and title
            Image(systemName: "building.columns.fill") // a ready made apple icon 
                .font(.system(size: 60)) // size of the icon (big)
                .foregroundStyle(.blue) // color 
            Text("Bankey")
                .font(.largeTitle.bold()) 


            // the 2 fields (user/pass)
            VStack(spacing: 12) {
                TextField("Customer number", text: $auth.customerNumber) //writen in grey and where the text should go
                    .keyboardType(.numberPad) // show the number keyboard
                    .textContentType(.username) // tells ios this is the username 
                SecureField("Password", text: $auth.password) // adds the dots when writing the password
                    .textContentType(.password) // this is a password 
            }
            .textFieldStyle(.roundedBorder) // its shape 

            if let error = auth.errorMessage { //if there is an error call it error
                Text(error)//show it
                    .font(.footnote)//small text
                    .foregroundStyle(.red) //color
                    .multilineTextAlignment(.center)
            }
            // login button label
            Button {
                Task { await auth.login() } // task means start a seperate job and run this inside it
            } label: { // what the button looks like 
                if auth.isLoading {
                    ProgressView() //show the loading thing 
                        .frame(maxWidth: .infinity) //size (big)
                } else {
                    Text("Log in") // show the word login
                        .frame(maxWidth: .infinity)
                }
            }
            //login button style
            .buttonStyle(.borderedProminent) //filled with color
            .controlSize(.large) //large size
            .disabled(auth.isLoading) //turn it off when waiting for the sever

            //2 stretchy empty spaces 
            Spacer()
            Spacer()
        }
        .padding(24)
    }
}
//Show this in Xcode’s preview panel
#Preview {
    //draw the login screen 
    LoginView(auth: AuthViewModel())
}
// padding = fixed gap so nothing touches the screen edges
// Spacer = invisible spring that pushes items (2 at the bottom, 1 on top = content sits a bit higher)
