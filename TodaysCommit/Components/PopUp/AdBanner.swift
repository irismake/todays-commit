import Foundation
import GoogleMobileAds
import SwiftUI

struct AdBanner: UIViewRepresentable {
  let adUnitID: String

  func makeUIView(context _: Context) -> BannerView {
    let bannerView = BannerView(adSize: adSizeFor(cgSize: CGSize(width: 320, height: 50)))
    bannerView.adUnitID = adUnitID
    
    if let rootViewController = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .flatMap(\.windows)
      .first(where: { $0.isKeyWindow })?.rootViewController
    {
      bannerView.rootViewController = rootViewController
    }
    
    bannerView.load(Request())
    return bannerView
  }

  func updateUIView(_: BannerView, context _: Context) {}
}
