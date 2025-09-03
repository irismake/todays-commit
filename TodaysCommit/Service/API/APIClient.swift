import Foundation

actor APIClient {
  static let shared = APIClient()
  private let baseURL = AppConfig.baseURL
  private var isRefreshing = false

  func requestJSON<T: Decodable>(
    path: String,
    query: [URLQueryItem] = [],
    method: String = "GET",
    body: Data? = nil,
    response: T.Type,
    authRequired: Bool = false,
    attempt: Int = 0
  ) async throws -> T {
    let url = try makeURL(path: path, query: query)
        
    var req = URLRequest(url: url)
    req.httpMethod = method
    req.httpBody = body
    req.setValue("application/json", forHTTPHeaderField: "Accept")
    if body != nil {
      req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    if authRequired {
      guard let accessToken = UserSessionManager.accessToken else {
        throw CustomError.tokenMissing
      }
      req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
   
    do {
      let (data, resp) = try await URLSession.shared.data(for: req)
        
      guard let http = resp as? HTTPURLResponse else {
        throw CustomError.noData
      }

      if http.statusCode == 401 {
        guard attempt == 0 else {
          throw CustomError.unauthorized
        }
        try await getRefreshToken()
        return try await requestJSON(
          path: path,
          query: query,
          method: method,
          body: body,
          response: response,
          authRequired: authRequired,
          attempt: attempt + 1
        )
      }

      guard (200 ... 299).contains(http.statusCode) else {
        throw CustomError.serverError(statusCode: http.statusCode, data: data)
      }

      return try decode(data: data, as: T.self)
    } catch {
      throw errorMappping(error)
    }
  }
    
  func requestHTML(path: String, query: [URLQueryItem] = []) async throws -> String {
    var urlComponents = URLComponents(string: baseURL + path)!
    urlComponents.queryItems = query
            
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
            
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
            
    return String(data: data, encoding: .utf8) ?? ""
  }

  private func getRefreshToken() async throws {
    if isRefreshing {
      while isRefreshing {
        try await Task.sleep(nanoseconds: 120_000_000)
      }
      return
    }
    isRefreshing = true
    defer { isRefreshing = false }
    do {
      try await TokenAPI.updateToken()
    } catch CustomError.unauthorized {
      UserSessionManager.clearStorgeData()
      throw CustomError.unauthorized
    } catch {
      throw error
    }
  }
    
  private func makeURL(path: String, query: [URLQueryItem]) throws -> URL {
    guard var component = URLComponents(string: baseURL + path) else {
      throw CustomError.invalidURL
    }
    if !query.isEmpty {
      component.queryItems = query
    }
    guard let url = component.url else {
      throw CustomError.invalidURL
    }
    return url
  }
    
  private func decode<T: Decodable>(data: Data, as _: T.Type) throws -> T {
    let dec = JSONDecoder()
    dec.keyDecodingStrategy = .convertFromSnakeCase
    do { return try dec.decode(T.self, from: data) }
    catch { throw CustomError.decodingError(error) }
  }
    
  private func errorMappping(_ error: Error) -> CustomError {
    if let urlErr = error as? URLError {
      return .networkError(urlErr)
    }
    return .networkError(error)
  }
}
