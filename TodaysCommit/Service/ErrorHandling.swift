import Foundation

enum KakaoLoginError: Error, LocalizedError {
  case tokenMissing
  case networkError(Error)
  case decodingError(Error)
  case serverError(Error)
  case noData

  var errorDescription: String? {
    switch self {
    case .tokenMissing: return "accessToken이 없습니다."
    case let .networkError(err): return "네트워크 오류: \(err.localizedDescription)"
    case let .decodingError(err): return "디코딩 오류: \(err.localizedDescription)"
    case let .serverError(err): return "서버 오류: \(err.localizedDescription)"
    case .noData: return "서버 응답 데이터가 없습니다."
    }
  }
}

enum AppleLoginError: Error, LocalizedError {
  case tokenMissing
  case networkError(Error)
  case decodingError(Error)
  case serverError(Error)
  case noData
  case invalidCredential
  case canceled
  case unknown(Error)

  var errorDescription: String? {
    switch self {
    case .tokenMissing:
      return "identityToken이 없습니다."
    case let .networkError(err): return "네트워크 오류: \(err.localizedDescription)"
    case let .decodingError(err): return "디코딩 오류: \(err.localizedDescription)"
    case let .serverError(err): return "서버 오류: \(err.localizedDescription)"
    case .noData: return "서버 응답 데이터가 없습니다."
    case .invalidCredential:
      return "Apple 로그인 자격 정보가 올바르지 않습니다."
    case .canceled:
      return "사용자가 Apple 로그인을 취소했습니다."
    case let .unknown(err):
      return "알 수 없는 오류: \(err.localizedDescription)"
    }
  }
}

enum CustomError: Error, LocalizedError {
  case tokenMissing
  case networkError(Error)
  case decodingError(Error)
  case serverError(Error)
  case noData
  case unknown(Error)

  var errorDescription: String? {
    switch self {
    case .tokenMissing:
      return "identityToken이 없습니다."
    case let .networkError(err): return "네트워크 오류: \(err.localizedDescription)"
    case let .decodingError(err): return "디코딩 오류: \(err.localizedDescription)"
    case let .serverError(err): return "서버 오류: \(err.localizedDescription)"
    case .noData: return "서버 응답 데이터가 없습니다."
    case let .unknown(err):
      return "알 수 없는 오류: \(err.localizedDescription)"
    }
  }
}
