import Foundation

// Errors the app can show to the user.
enum APIError: LocalizedError {
    case unauthorized          // 401: token missing or expired -> back to login
    case server(String)        // any other error, with the server's message
    case cannotConnect         // server is off or unreachable

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Your session has ended. Please log in again."
        case .server(let message): return message
        case .cannotConnect: return "Cannot reach the server. Is it running?"
        }
    }
}

// The server's error body looks like {"message": "..."}
private struct ErrorResponse: Decodable {
    let message: String?
}

// The app's "phone line" to the Spring Boot server.
final class APIClient {
    static let shared = APIClient()

    // The ONE place with the server address.
    // Simulator: localhost. Real iPhone: your Mac's Wi-Fi address, e.g. http://192.168.1.20:8080
    private let baseURL = URL(string: "http://localhost:8080")!

    // POST /auth/login -> returns the token
    func login(customerNumber: Int, password: String) async throws -> String {
        let body = try JSONEncoder().encode(LoginRequest(customerNumber: customerNumber, password: password))
        let response: LoginResponse = try await send("auth/login", method: "POST", body: body, needsToken: false)
        return response.token
    }

    // GET /accounts
    func getAccounts() async throws -> [Account] {
        try await send("accounts")
    }

    // GET /accounts/{accountNumber}
    func getAccount(_ accountNumber: String) async throws -> Account {
        try await send("accounts/\(accountNumber)")
    }

    // PATCH /accounts/{accountNumber}/nickname
    func updateNickname(accountNumber: String, nickname: String) async throws -> Account {
        let body = try JSONEncoder().encode(NicknameRequest(nickname: nickname))
        return try await send("accounts/\(accountNumber)/nickname", method: "PATCH", body: body)
    }

    // Builds the request, adds the token, sends it, and reads the answer.
    private func send<T: Decodable>(_ path: String,
                                    method: String = "GET",
                                    body: Data? = nil,
                                    needsToken: Bool = true) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        if needsToken {
            guard let token = KeychainHelper.readToken() else { throw APIError.unauthorized }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

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
