import SwiftUI

import WebKit

struct PlaceMapCard: UIViewRepresentable {
  let lat: Double
  let lon: Double

  private let baseURL = AppConfig.baseURL

  func makeUIView(context _: Context) -> WKWebView {
    let webView = WKWebView()
    loadMap(into: webView)
    return webView
  }

  func updateUIView(_: WKWebView, context _: Context) {}
    
  private func loadMap(into webView: WKWebView) {
    Task {
      let html = try await PlaceAPI.getPlaceMap(lat: lat, lon: lon)
      webView.loadHTMLString(html, baseURL: URL(string: baseURL))
    }
  }
}
