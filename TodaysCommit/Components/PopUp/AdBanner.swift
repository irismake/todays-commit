import GoogleMobileAds
import SwiftUI

struct AdBanner: UIViewRepresentable {
  private let adUnitID: String

  init() {
    #if DEBUG
      adUnitID = "ca-app-pub-3940256099942544/2934735716"
    #else
      adUnitID = Bundle.main.infoDictionary?["SDK_ID"] as? String ?? ""
    #endif
  }
    
  func makeUIView(context _: Context) -> UIView {
    let containerView = UIView()
    let screenWidth = UIScreen.main.bounds.width

    let adSize = portraitAnchoredAdaptiveBanner(width: screenWidth)
    let bannerView = BannerView(adSize: adSize)
        
    bannerView.adUnitID = adUnitID
    bannerView.translatesAutoresizingMaskIntoConstraints = false
        
    if let rootViewController = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .flatMap(\.windows)
      .first(where: { $0.isKeyWindow })?.rootViewController
    {
      bannerView.rootViewController = rootViewController
    }
        
    containerView.addSubview(bannerView)
    containerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 50)
        
    NSLayoutConstraint.activate([
      bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      bannerView.widthAnchor.constraint(equalToConstant: screenWidth),
      bannerView.heightAnchor.constraint(equalToConstant: 50)
    ])
        
    let request = Request()
    bannerView.load(request)
        
    return containerView
  }
    
  func updateUIView(_: UIView, context _: Context) {}
}
