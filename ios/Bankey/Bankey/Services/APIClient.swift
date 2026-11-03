import Foundation

// Errors the app can show to the user.
enum APIError: LocalizedError { //localizederror is apples rule for an error that has a human-readable message 
    case unauthorized          // 401: token missing or expired -> back to login
    case server(String)        // any other error, with the server's message
    case cannotConnect         // server is off or unreachable

    var errorDescription: String? { // we should name it this way because apple looks for exactly this name 
        switch self { //look at which choice this error is
        case .unauthorized: return "Your session has ended. Please log in again."
        case .server(let message): return message
        case .cannotConnect: return "Cannot reach the server. Is it running?"
        }
    }
}

// The server's error body looks like {"message": "..."}
//struct: simple data box 
private struct ErrorResponse: Decodable { // it ca be read from json 
    let message: String? //find message 
}

// The app's "phone line" to the Spring Boot server.
//final -> no othger class can extend it 
final class APIClient {
    static let shared = APIClient() // create one apiclient and keep it here

    //the server address.
    #if targetEnvironment(simulator) //are we building for the simulator?
    // The simulator runs on the Mac
    private let baseURL = URL(string: "http://localhost:8080")! //! means im sure this address is valid 
    #else
    // A real iPhone finds the Mac by its network name (same Wi-Fi or hotspot).
    private let baseURL = URL(string: "http://Dalals-MacBook-Air.local:8080")!
    #endif
    
    // POST /auth/login -> returns the token
    func login(customerNumber: Int, password: String) async throws -> String { //async: wait for the server , throw: it can fail (thow an error), it returns taxt(token)
        //fill the login box, swift -> json, .encode: translate to json bytes
        let body = try JSONEncoder().encode(LoginRequest(customerNumber: customerNumber, password: password))
        
        let response: LoginResponse = try await send("auth/login", method: "POST", body: body, needsToken: false)// dont attach a token because we dont have one yet
        return response.token
    }

    // GET /accounts
    func getAccounts() async throws -> [Account] { // returns list of accounts 
        try await send("accounts")// do a get on accounts
    }

    // GET /accounts/{accountNumber}
    func getAccount(_ accountNumber: String) async throws -> Account { //_no label when calling 
        try await send("accounts/\(accountNumber)") // \ means put the value inside the text "accounts/1000001"
    }

    // PATCH /accounts/{accountNumber}/nickname
    func updateNickname(accountNumber: String, nickname: String) async throws -> Account {
        let body = try JSONEncoder().encode(NicknameRequest(nickname: nickname))
        return try await send("accounts/\(accountNumber)/nickname", method: "PATCH", body: body)
    }

    // Builds the request, adds the token, sends it, and reads the answer.
   // T is a blank type to be filled later (readable by json)
   //I used T because the function handles all 4 calls. without T wed need 4 almost identical copies 
    private func send<T: Decodable>(_ path: String, 
                                    method: String = "GET",
                                    body: Data? = nil,
                                    needsToken: Bool = true) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path)) //join the address and the path with a /
        request.httpMethod = method //get post patch
        request.timeoutInterval = 15 // If there’s no reply within 15 seconds, give up
        // Tell the server the body is JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Put the JSON inside the request 
        request.httpBody = body

        if needsToken {
            //try to get token if its nil, stop here
            guard let token = KeychainHelper.readToken() else { throw APIError.unauthorized }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
/////////////////////////////////////////////////////////////////
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.cannotConnect
        }

        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        if status == 401 && needsToken {
            throw APIError.unauthorized
        }
        guard (200...299).contains(status) else {
            let message = (try? JSONDecoder().decode(ErrorResponse.self, from: data))?.message
            throw APIError.server(message ?? "Something went wrong (error \(status)).")
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
