import Foundation

enum KakaoLoginError: Error, LocalizedError {
  case tokenMissing
  case networkError(Error)
  case decodingError(Error)
  case noData

  var errorDescription: String? {
    switch self {
    case .tokenMissing: return "accessToken이 없습니다."
    case let .networkError(err): return "네트워크 오류: \(err.localizedDescription)"
    case let .decodingError(err): return "디코딩 오류: \(err.localizedDescription)"
    case .noData: return "서버 응답 데이터가 없습니다."
    }
  }
}
